import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wordbook/database/settings_model.dart';
import 'wordbook_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Wordbook.db");
    return await openDatabase(path, version: 1, onOpen: (db) async {
      await createSettingsTableIfNotExists(db);
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Meta ("
          "wordCount INTEGER"
          ")");
      await db.insert("Meta", {"wordCount": 0});
      await db.execute("CREATE TABLE Words ("
          "id TEXT,"
          "original TEXT,"
          "translations TEXT,"
          "isLearned BIT"
          ")");
      await createSettingsTableIfNotExists(db);
    });
  }

  Future<void> createSettingsTableIfNotExists(Database db) async {
    await db.execute("CREATE TABLE IF NOT EXISTS Settings ("
        "setting TEXT,"
        "value TEXT,"
        "UNIQUE(setting)"
        ")");
    //the list of settings and their default values
    Map<String, String> settings = {'Theme': 'Auto'};
    settings.forEach((key, value) async {
      await db.execute(
          'INSERT OR IGNORE INTO Settings(setting, value) VALUES(?, ?)',
          [key, value]);
    });
  }

  getSetting(String setting) async {
    final db = await database;
    var res =
        await db.query("Settings", where: 'setting = ?', whereArgs: [setting]);
    return (res.isNotEmpty ? res.first['value'] : "");
  }

  Future<Settings> getAllSettings() async {
    final db = await database;
    var res = await db.query("Settings");
    return res.isNotEmpty ? Settings.fromJson(res) : Settings();
  }

  setSetting(String setting, String value) async {
    final db = await database;
    var res = await db.update("Settings", {'setting': setting, 'value': value});
    return res;
  }

  newWord(Word newWord) async {
    final db = await database;
    var wordWithId = newWord.toJson();
    Uuid idGenerator = Uuid();
    wordWithId['id'] = idGenerator.v4();
    var res = await db.insert("Words", wordWithId);
    _incrementWordsCount();
    return res;
  }

  getFirstWordByOriginal(String original) async {
    final db = await database;
    var res =
        await db.query('Words', where: 'original = ?', whereArgs: [original]);
    return res.isNotEmpty ? Word.fromJson(res.first) : Null;
  }

  Future<Word> getWordById(String id) async {
    final db = await database;
    var res = await db.query("Words", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Word.fromJson(res.first) : Null;
  }

  Future<List<Word>> getRandomWords(num length) async {
    final db = await database;
    var res = await db.query("Words", orderBy: 'RANDOM()', limit: length);
    List<Word> list =
        res.isNotEmpty ? res.map((c) => Word.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<Word>> getAllWords() async {
    final db = await database;
    var res = await db.query("Words");
    List<Word> list =
        res.isNotEmpty ? res.map((c) => Word.fromJson(c)).toList() : [];
    return list;
  }

  Future<num> getWordCount() async {
    final db = await database;
    var res = await db.query("Meta");
    return res.isNotEmpty ? Meta.fromJson(res.first).wordCount : Null;
  }

  updateWord(Word editedWord) async {
    final db = await database;
    var res = await db.update("Words", editedWord.toJson(),
        where: "id = ?", whereArgs: [editedWord.id]);
    return res;
  }

  deleteWord(String id) async {
    final db = await database;
    db.delete("Words", where: "id = ?", whereArgs: [id]);
    _decrementWordsCount();
  }

  _incrementWordsCount() async {
    final db = await database;
    var currentCount = (await db.query("Meta")).first['wordCount'];
    currentCount++;
    var res = await db.execute("UPDATE Meta SET wordCount=$currentCount;");
    return res;
  }

  _decrementWordsCount() async {
    final db = await database;
    var currentCount = (await db.query("Meta")).first['wordCount'];
    currentCount++;
    var res = await db.execute("UPDATE Meta SET wordCount=$currentCount;");
    return res;
  }
}
