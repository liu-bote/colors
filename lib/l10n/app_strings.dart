/// Lightweight in-app localization: one [AppStrings] instance per supported
/// UI language, selected by the primary language in settings.
class AppLanguage {
  final String code;

  /// Name shown in the language picker, always in its own language.
  final String nativeName;

  /// Whether the language is written right-to-left; drives the app's
  /// [Directionality].
  final bool rtl;

  const AppLanguage(this.code, this.nativeName, {this.rtl = false});
}

const List<AppLanguage> supportedLanguages = [
  AppLanguage('en', 'English'),
  AppLanguage('zh', '简体中文'),
  AppLanguage('zh-Hant', '繁體中文'),
  AppLanguage('es', 'Español'),
  AppLanguage('fr', 'Français'),
  AppLanguage('de', 'Deutsch'),
  AppLanguage('ja', 'にほんご'),
  AppLanguage('ko', '한국어'),
  AppLanguage('pt', 'Português'),
  AppLanguage('it', 'Italiano'),
  AppLanguage('nl', 'Nederlands'),
  AppLanguage('ru', 'Русский'),
  AppLanguage('pl', 'Polski'),
  AppLanguage('tr', 'Türkçe'),
  AppLanguage('ar', 'العربية', rtl: true),
  AppLanguage('hi', 'हिन्दी'),
  AppLanguage('id', 'Bahasa Indonesia'),
  AppLanguage('th', 'ไทย'),
  AppLanguage('vi', 'Tiếng Việt'),
  AppLanguage('sv', 'Svenska'),
  AppLanguage('da', 'Dansk'),
  AppLanguage('no', 'Norsk'),
  AppLanguage('fi', 'Suomi'),
];

class AppStrings {
  final String appTitle;
  final String tagline;
  final String start;
  final String Function(int level) bestLevel;
  final String challenge;
  final String Function(int level, int max) levelLabel;
  final String timeUp;
  final String wrongTap;
  final String found;
  final String hint;
  final String reviveTitle;
  final String reviveBody;
  final String giveUp;
  final String watchAd;
  final String gameOverTitle;
  final String Function(int level) gameOverBody;
  final String goHome;
  final String playAgain;
  final String victoryTitle;
  final String Function(int colorCount) victoryBody;
  final String settingsTitle;
  final String languageLabel;
  final String secondLanguageLabel;
  final String secondLanguageHint;
  final String none;
  final String done;

  const AppStrings({
    required this.appTitle,
    required this.tagline,
    required this.start,
    required this.bestLevel,
    required this.challenge,
    required this.levelLabel,
    required this.timeUp,
    required this.wrongTap,
    required this.found,
    required this.hint,
    required this.reviveTitle,
    required this.reviveBody,
    required this.giveUp,
    required this.watchAd,
    required this.gameOverTitle,
    required this.gameOverBody,
    required this.goHome,
    required this.playAgain,
    required this.victoryTitle,
    required this.victoryBody,
    required this.settingsTitle,
    required this.languageLabel,
    required this.secondLanguageLabel,
    required this.secondLanguageHint,
    required this.none,
    required this.done,
  });
}

AppStrings appStringsFor(String lang) => _byLang[lang] ?? _en;

final Map<String, AppStrings> _byLang = {
  'en': _en,
  'zh': _zh,
  'zh-Hant': _zhHant,
  'es': _es,
  'fr': _fr,
  'de': _de,
  'ja': _ja,
  'ko': _ko,
  'pt': _pt,
  'it': _it,
  'nl': _nl,
  'ru': _ru,
  'pl': _pl,
  'tr': _tr,
  'ar': _ar,
  'hi': _hi,
  'id': _id,
  'th': _th,
  'vi': _vi,
  'sv': _sv,
  'da': _da,
  'no': _no,
  'fi': _fi,
};

final AppStrings _en = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Spot the odd tile · Learn Crayola colors',
  start: 'Start Game',
  bestLevel: (l) => 'Best: level $l',
  challenge: 'Take on all 100 levels!',
  levelLabel: (l, m) => 'Level $l / $m',
  timeUp: "⏰ Time's up!",
  wrongTap: '❌ Wrong tile!',
  found: '🎉 Found it!',
  hint: '👆 Find the tile with a different color and tap it!',
  reviveTitle: '💔 Out of lives!',
  reviveBody:
      'Watch an ad to revive with 2 lives and keep going from this level.\n'
      'Only one revive per run — closing the ad early won\'t count.',
  giveUp: 'Give up',
  watchAd: 'Watch ad to revive',
  gameOverTitle: 'Game over',
  gameOverBody: (l) =>
      'You reached level $l.\nA fresh run is free — try again!',
  goHome: 'Home',
  playAgain: 'Play again',
  victoryTitle: 'You did it!',
  victoryBody: (n) => 'You cleared all 100 levels\nand met $n Crayola colors!',
  settingsTitle: 'Language',
  languageLabel: 'Language',
  secondLanguageLabel: 'Second language (learning)',
  secondLanguageHint:
      'Shown under each color name to help learn a new language.',
  none: 'None',
  done: 'Done',
);

final AppStrings _zh = AppStrings(
  appTitle: '色差挑战',
  tagline: '找出不一样的方块 · 认识 Crayola 颜色',
  start: '开始游戏',
  bestLevel: (l) => '最高纪录：第 $l 关',
  challenge: '来挑战 100 关吧！',
  levelLabel: (l, m) => '第 $l / $m 关',
  timeUp: '⏰ 时间到！',
  wrongTap: '❌ 点错了！',
  found: '🎉 找到了！',
  hint: '👆 找出颜色不一样的方块，点它！',
  reviveTitle: '💔 没命啦！',
  reviveBody: '看一段广告即可复活，获得 2 条命，继续挑战当前关卡。\n本局仅有一次复活机会，中途关闭广告无效哦。',
  giveUp: '放弃',
  watchAd: '看广告复活',
  gameOverTitle: '本局结束',
  gameOverBody: (l) => '你挑战到了第 $l 关。\n再接再厉，新的一局免费开始！',
  goHome: '回主页',
  playAgain: '再来一局',
  victoryTitle: '恭喜通关！',
  victoryBody: (n) => '你完成了全部 100 关，\n还认识了 $n 种 Crayola 颜色！',
  settingsTitle: '语言',
  languageLabel: '语言',
  secondLanguageLabel: '第二语言（学习）',
  secondLanguageHint: '会显示在颜色名字下方，帮助学习新语言。',
  none: '无',
  done: '完成',
);

final AppStrings _es = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Encuentra la ficha diferente · Aprende los colores Crayola',
  start: 'Jugar',
  bestLevel: (l) => 'Récord: nivel $l',
  challenge: '¡Supera los 100 niveles!',
  levelLabel: (l, m) => 'Nivel $l / $m',
  timeUp: '⏰ ¡Se acabó el tiempo!',
  wrongTap: '❌ ¡Ficha equivocada!',
  found: '🎉 ¡La encontraste!',
  hint: '👆 ¡Busca la ficha de color diferente y tócala!',
  reviveTitle: '💔 ¡Sin vidas!',
  reviveBody:
      'Mira un anuncio para revivir con 2 vidas y seguir en este nivel.\n'
      'Solo un revivir por partida; cerrar el anuncio antes no cuenta.',
  giveUp: 'Rendirse',
  watchAd: 'Ver anuncio y revivir',
  gameOverTitle: 'Fin de la partida',
  gameOverBody: (l) =>
      'Llegaste al nivel $l.\nUna nueva partida es gratis. ¡Inténtalo otra vez!',
  goHome: 'Inicio',
  playAgain: 'Jugar otra vez',
  victoryTitle: '¡Lo lograste!',
  victoryBody: (n) =>
      '¡Superaste los 100 niveles\ny conociste $n colores Crayola!',
  settingsTitle: 'Idioma',
  languageLabel: 'Idioma',
  secondLanguageLabel: 'Segundo idioma (aprendizaje)',
  secondLanguageHint:
      'Se muestra debajo de cada nombre de color para aprender un idioma nuevo.',
  none: 'Ninguno',
  done: 'Listo',
);

final AppStrings _fr = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Trouve la case différente · Apprends les couleurs Crayola',
  start: 'Jouer',
  bestLevel: (l) => 'Record : niveau $l',
  challenge: 'Relève les 100 niveaux !',
  levelLabel: (l, m) => 'Niveau $l / $m',
  timeUp: '⏰ Temps écoulé !',
  wrongTap: '❌ Mauvaise case !',
  found: '🎉 Trouvé !',
  hint: '👆 Trouve la case d\'une couleur différente et touche-la !',
  reviveTitle: '💔 Plus de vies !',
  reviveBody:
      'Regarde une pub pour revivre avec 2 vies et continuer ce niveau.\n'
      'Une seule résurrection par partie ; fermer la pub avant la fin ne compte pas.',
  giveUp: 'Abandonner',
  watchAd: 'Voir la pub et revivre',
  gameOverTitle: 'Partie terminée',
  gameOverBody: (l) =>
      'Tu as atteint le niveau $l.\nUne nouvelle partie est gratuite. Réessaie !',
  goHome: 'Accueil',
  playAgain: 'Rejouer',
  victoryTitle: 'Bravo !',
  victoryBody: (n) =>
      'Tu as réussi les 100 niveaux\net découvert $n couleurs Crayola !',
  settingsTitle: 'Langue',
  languageLabel: 'Langue',
  secondLanguageLabel: 'Deuxième langue (apprentissage)',
  secondLanguageHint:
      'Affichée sous chaque nom de couleur pour apprendre une nouvelle langue.',
  none: 'Aucune',
  done: 'OK',
);

final AppStrings _de = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Finde das andere Feld · Lerne die Crayola-Farben',
  start: 'Spielen',
  bestLevel: (l) => 'Rekord: Level $l',
  challenge: 'Schaffe alle 100 Level!',
  levelLabel: (l, m) => 'Level $l / $m',
  timeUp: '⏰ Zeit ist um!',
  wrongTap: '❌ Falsches Feld!',
  found: '🎉 Gefunden!',
  hint: '👆 Finde das Feld mit der anderen Farbe und tippe darauf!',
  reviveTitle: '💔 Keine Leben mehr!',
  reviveBody:
      'Schau eine Werbung, um mit 2 Leben in diesem Level weiterzumachen.\n'
      'Nur eine Wiederbelebung pro Runde; vorzeitiges Schließen zählt nicht.',
  giveUp: 'Aufgeben',
  watchAd: 'Werbung schauen',
  gameOverTitle: 'Runde vorbei',
  gameOverBody: (l) =>
      'Du hast Level $l erreicht.\nEine neue Runde ist gratis. Versuch es nochmal!',
  goHome: 'Start',
  playAgain: 'Nochmal spielen',
  victoryTitle: 'Geschafft!',
  victoryBody: (n) =>
      'Du hast alle 100 Level geschafft\nund $n Crayola-Farben kennengelernt!',
  settingsTitle: 'Sprache',
  languageLabel: 'Sprache',
  secondLanguageLabel: 'Zweite Sprache (Lernen)',
  secondLanguageHint:
      'Wird unter jedem Farbnamen angezeigt, um eine neue Sprache zu lernen.',
  none: 'Keine',
  done: 'Fertig',
);

final AppStrings _ja = AppStrings(
  appTitle: 'いろさがし',
  tagline: 'ちがういろを みつけよう · クレヨラのいろをおぼえよう',
  start: 'スタート',
  bestLevel: (l) => 'さいこうきろく：レベル $l',
  challenge: '100レベルに ちょうせんしよう！',
  levelLabel: (l, m) => 'レベル $l / $m',
  timeUp: '⏰ じかんぎれ！',
  wrongTap: '❌ ちがうよ！',
  found: '🎉 みつけた！',
  hint: '👆 いろがちがうマスをさがして タップ！',
  reviveTitle: '💔 ライフがなくなった！',
  reviveBody:
      'こうこくをみると ライフが2つもどって つづきからあそべるよ。\n'
      'ふっかつは1かいだけ。とちゅうでとじると むこうだよ。',
  giveUp: 'やめる',
  watchAd: 'こうこくをみてふっかつ',
  gameOverTitle: 'ゲームおわり',
  gameOverBody: (l) => 'レベル $l まで がんばったね。\nあたらしいゲームは むりょうだよ！',
  goHome: 'ホームへ',
  playAgain: 'もういちど',
  victoryTitle: 'クリアおめでとう！',
  victoryBody: (n) => '100レベル ぜんぶクリア！\n$n しょくの クレヨラのいろを おぼえたよ！',
  settingsTitle: 'ことば',
  languageLabel: 'ことば',
  secondLanguageLabel: 'ふたつめのことば（がくしゅう）',
  secondLanguageHint: 'いろのなまえのしたに ひょうじされて、あたらしいことばをおぼえられるよ。',
  none: 'なし',
  done: 'できた',
);

final AppStrings _ko = AppStrings(
  appTitle: '색깔 찾기',
  tagline: '다른 색 타일 찾기 · 크레욜라 색깔 배우기',
  start: '게임 시작',
  bestLevel: (l) => '최고 기록: $l단계',
  challenge: '100단계에 도전해 보세요!',
  levelLabel: (l, m) => '$l / $m 단계',
  timeUp: '⏰ 시간 종료!',
  wrongTap: '❌ 틀렸어요!',
  found: '🎉 찾았어요!',
  hint: '👆 색이 다른 타일을 찾아서 눌러 보세요!',
  reviveTitle: '💔 생명이 다 됐어요!',
  reviveBody:
      '광고를 보면 생명 2개로 부활해서 이번 단계를 계속할 수 있어요.\n'
      '부활은 한 판에 한 번뿐이에요. 광고를 중간에 닫으면 무효예요.',
  giveUp: '포기',
  watchAd: '광고 보고 부활',
  gameOverTitle: '게임 종료',
  gameOverBody: (l) => '$l단계까지 도전했어요.\n새 게임은 무료예요. 다시 도전해 보세요!',
  goHome: '홈으로',
  playAgain: '한 판 더',
  victoryTitle: '축하해요!',
  victoryBody: (n) => '100단계를 모두 통과하고\n크레욜라 색깔 $n가지를 배웠어요!',
  settingsTitle: '언어',
  languageLabel: '언어',
  secondLanguageLabel: '두 번째 언어 (학습)',
  secondLanguageHint: '색깔 이름 아래에 표시되어 새로운 언어를 배울 수 있어요.',
  none: '없음',
  done: '완료',
);

final AppStrings _zhHant = AppStrings(
  appTitle: '色差挑戰',
  tagline: '找出不一樣的方塊 · 認識 Crayola 顏色',
  start: '開始遊戲',
  bestLevel: (l) => '最高紀錄：第 $l 關',
  challenge: '來挑戰 100 關吧！',
  levelLabel: (l, m) => '第 $l / $m 關',
  timeUp: '⏰ 時間到！',
  wrongTap: '❌ 點錯了！',
  found: '🎉 找到了！',
  hint: '👆 找出顏色不一樣的方塊，點它！',
  reviveTitle: '💔 沒命啦！',
  reviveBody: '看一段廣告即可復活，獲得 2 條命，繼續挑戰目前關卡。\n本局僅有一次復活機會，中途關閉廣告無效喔。',
  giveUp: '放棄',
  watchAd: '看廣告復活',
  gameOverTitle: '本局結束',
  gameOverBody: (l) => '你挑戰到了第 $l 關。\n再接再厲，新的一局免費開始！',
  goHome: '回主頁',
  playAgain: '再來一局',
  victoryTitle: '恭喜通關！',
  victoryBody: (n) => '你完成了全部 100 關，\n還認識了 $n 種 Crayola 顏色！',
  settingsTitle: '語言',
  languageLabel: '語言',
  secondLanguageLabel: '第二語言（學習）',
  secondLanguageHint: '會顯示在顏色名字下方，幫助學習新語言。',
  none: '無',
  done: '完成',
);

final AppStrings _pt = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Ache o quadrado diferente · Aprenda as cores Crayola',
  start: 'Jogar',
  bestLevel: (l) => 'Recorde: nível $l',
  challenge: 'Encare os 100 níveis!',
  levelLabel: (l, m) => 'Nível $l / $m',
  timeUp: '⏰ Acabou o tempo!',
  wrongTap: '❌ Quadrado errado!',
  found: '🎉 Achou!',
  hint: '👆 Ache o quadrado de cor diferente e toque nele!',
  reviveTitle: '💔 Sem vidas!',
  reviveBody:
      'Assista a um anúncio para reviver com 2 vidas e continuar deste nível.\n'
      'Só um revive por partida; fechar o anúncio antes não conta.',
  giveUp: 'Desistir',
  watchAd: 'Ver anúncio e reviver',
  gameOverTitle: 'Fim de jogo',
  gameOverBody: (l) =>
      'Você chegou ao nível $l.\nUma nova partida é grátis. Tente de novo!',
  goHome: 'Início',
  playAgain: 'Jogar de novo',
  victoryTitle: 'Você conseguiu!',
  victoryBody: (n) => 'Você venceu os 100 níveis\ne conheceu $n cores Crayola!',
  settingsTitle: 'Idioma',
  languageLabel: 'Idioma',
  secondLanguageLabel: 'Segundo idioma (aprendizado)',
  secondLanguageHint:
      'Aparece abaixo de cada nome de cor para ajudar a aprender um idioma novo.',
  none: 'Nenhum',
  done: 'Pronto',
);

final AppStrings _it = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Trova la casella diversa · Impara i colori Crayola',
  start: 'Gioca',
  bestLevel: (l) => 'Record: livello $l',
  challenge: 'Supera tutti i 100 livelli!',
  levelLabel: (l, m) => 'Livello $l / $m',
  timeUp: '⏰ Tempo scaduto!',
  wrongTap: '❌ Casella sbagliata!',
  found: '🎉 Trovata!',
  hint: '👆 Trova la casella di colore diverso e toccala!',
  reviveTitle: '💔 Vite finite!',
  reviveBody:
      'Guarda una pubblicità per rivivere con 2 vite e continuare da questo livello.\n'
      'Solo una resurrezione a partita; chiudere la pubblicità prima non conta.',
  giveUp: 'Arrenditi',
  watchAd: 'Guarda la pubblicità',
  gameOverTitle: 'Partita finita',
  gameOverBody: (l) =>
      'Sei arrivato al livello $l.\nUna nuova partita è gratis. Riprova!',
  goHome: 'Home',
  playAgain: 'Gioca ancora',
  victoryTitle: 'Ce l\'hai fatta!',
  victoryBody: (n) =>
      'Hai superato tutti i 100 livelli\ne conosciuto $n colori Crayola!',
  settingsTitle: 'Lingua',
  languageLabel: 'Lingua',
  secondLanguageLabel: 'Seconda lingua (apprendimento)',
  secondLanguageHint:
      'Mostrata sotto ogni nome di colore per imparare una nuova lingua.',
  none: 'Nessuna',
  done: 'Fatto',
);

final AppStrings _nl = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Vind het andere vakje · Leer de Crayola-kleuren',
  start: 'Spelen',
  bestLevel: (l) => 'Record: level $l',
  challenge: 'Haal alle 100 levels!',
  levelLabel: (l, m) => 'Level $l / $m',
  timeUp: '⏰ Tijd is om!',
  wrongTap: '❌ Verkeerd vakje!',
  found: '🎉 Gevonden!',
  hint: '👆 Zoek het vakje met de andere kleur en tik erop!',
  reviveTitle: '💔 Geen levens meer!',
  reviveBody:
      'Bekijk een advertentie om met 2 levens verder te gaan vanaf dit level.\n'
      'Eén herleving per potje; de advertentie eerder sluiten telt niet.',
  giveUp: 'Opgeven',
  watchAd: 'Advertentie kijken',
  gameOverTitle: 'Spel voorbij',
  gameOverBody: (l) =>
      'Je haalde level $l.\nEen nieuw potje is gratis. Probeer het nog eens!',
  goHome: 'Home',
  playAgain: 'Nog een keer',
  victoryTitle: 'Gelukt!',
  victoryBody: (n) =>
      'Je hebt alle 100 levels gehaald\nen $n Crayola-kleuren leren kennen!',
  settingsTitle: 'Taal',
  languageLabel: 'Taal',
  secondLanguageLabel: 'Tweede taal (leren)',
  secondLanguageHint:
      'Wordt onder elke kleurnaam getoond om een nieuwe taal te leren.',
  none: 'Geen',
  done: 'Klaar',
);

final AppStrings _ru = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Найди другую клетку · Учи цвета Crayola',
  start: 'Играть',
  bestLevel: (l) => 'Рекорд: уровень $l',
  challenge: 'Пройди все 100 уровней!',
  levelLabel: (l, m) => 'Уровень $l / $m',
  timeUp: '⏰ Время вышло!',
  wrongTap: '❌ Не та клетка!',
  found: '🎉 Нашёл!',
  hint: '👆 Найди клетку другого цвета и нажми на неё!',
  reviveTitle: '💔 Жизни кончились!',
  reviveBody:
      'Посмотри рекламу, чтобы возродиться с 2 жизнями и продолжить с этого уровня.\n'
      'Только одно возрождение за игру; если закрыть рекламу раньше, не засчитается.',
  giveUp: 'Сдаться',
  watchAd: 'Смотреть рекламу',
  gameOverTitle: 'Игра окончена',
  gameOverBody: (l) =>
      'Ты дошёл до уровня $l.\nНовая игра бесплатна. Попробуй ещё раз!',
  goHome: 'Домой',
  playAgain: 'Ещё раз',
  victoryTitle: 'Получилось!',
  victoryBody: (n) => 'Ты прошёл все 100 уровней\nи узнал $n цветов Crayola!',
  settingsTitle: 'Язык',
  languageLabel: 'Язык',
  secondLanguageLabel: 'Второй язык (обучение)',
  secondLanguageHint:
      'Показывается под названием цвета, чтобы учить новый язык.',
  none: 'Нет',
  done: 'Готово',
);

final AppStrings _pl = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Znajdź inny kafelek · Poznaj kolory Crayola',
  start: 'Graj',
  bestLevel: (l) => 'Rekord: poziom $l',
  challenge: 'Pokonaj wszystkie 100 poziomów!',
  levelLabel: (l, m) => 'Poziom $l / $m',
  timeUp: '⏰ Czas minął!',
  wrongTap: '❌ Zły kafelek!',
  found: '🎉 Znalazłeś!',
  hint: '👆 Znajdź kafelek w innym kolorze i dotknij go!',
  reviveTitle: '💔 Koniec żyć!',
  reviveBody:
      'Obejrzyj reklamę, aby odrodzić się z 2 życiami i grać dalej od tego poziomu.\n'
      'Tylko jedno odrodzenie na grę; wcześniejsze zamknięcie reklamy się nie liczy.',
  giveUp: 'Poddaj się',
  watchAd: 'Obejrzyj reklamę',
  gameOverTitle: 'Koniec gry',
  gameOverBody: (l) =>
      'Dotarłeś do poziomu $l.\nNowa gra jest darmowa. Spróbuj jeszcze raz!',
  goHome: 'Start',
  playAgain: 'Zagraj ponownie',
  victoryTitle: 'Udało się!',
  victoryBody: (n) =>
      'Ukończyłeś wszystkie 100 poziomów\ni poznałeś $n kolorów Crayola!',
  settingsTitle: 'Język',
  languageLabel: 'Język',
  secondLanguageLabel: 'Drugi język (nauka)',
  secondLanguageHint:
      'Wyświetlany pod nazwą koloru, aby pomóc w nauce nowego języka.',
  none: 'Brak',
  done: 'Gotowe',
);

final AppStrings _tr = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Farklı kareyi bul · Crayola renklerini öğren',
  start: 'Oyna',
  bestLevel: (l) => 'Rekor: seviye $l',
  challenge: '100 seviyenin hepsini geç!',
  levelLabel: (l, m) => 'Seviye $l / $m',
  timeUp: '⏰ Süre doldu!',
  wrongTap: '❌ Yanlış kare!',
  found: '🎉 Buldun!',
  hint: '👆 Rengi farklı olan kareyi bul ve dokun!',
  reviveTitle: '💔 Can kalmadı!',
  reviveBody:
      'Reklam izleyerek 2 canla dirilebilir ve bu seviyeden devam edebilirsin.\n'
      'Her oyunda tek bir dirilme hakkı var; reklamı erken kapatmak sayılmaz.',
  giveUp: 'Pes et',
  watchAd: 'Reklam izle ve diril',
  gameOverTitle: 'Oyun bitti',
  gameOverBody: (l) =>
      '$l. seviyeye ulaştın.\nYeni oyun ücretsiz. Tekrar dene!',
  goHome: 'Ana sayfa',
  playAgain: 'Tekrar oyna',
  victoryTitle: 'Başardın!',
  victoryBody: (n) =>
      '100 seviyenin hepsini geçtin\nve $n Crayola rengi öğrendin!',
  settingsTitle: 'Dil',
  languageLabel: 'Dil',
  secondLanguageLabel: 'İkinci dil (öğrenme)',
  secondLanguageHint:
      'Yeni bir dil öğrenmene yardımcı olmak için renk adının altında gösterilir.',
  none: 'Yok',
  done: 'Tamam',
);

final AppStrings _ar = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'اعثر على المربع المختلف · تعلّم ألوان كرايولا',
  start: 'ابدأ اللعب',
  bestLevel: (l) => 'أفضل نتيجة: المستوى $l',
  challenge: 'تحدَّ المستويات المئة كلها!',
  levelLabel: (l, m) => 'المستوى $l / $m',
  timeUp: '⏰ انتهى الوقت!',
  wrongTap: '❌ مربع خاطئ!',
  found: '🎉 وجدته!',
  hint: '👆 ابحث عن المربع ذي اللون المختلف واضغط عليه!',
  reviveTitle: '💔 نفدت المحاولات!',
  reviveBody:
      'شاهد إعلاناً لتعود بمحاولتين وتكمل من هذا المستوى.\n'
      'عودة واحدة فقط في كل جولة؛ إغلاق الإعلان مبكراً لا يُحتسب.',
  giveUp: 'استسلام',
  watchAd: 'شاهد إعلاناً وعُد',
  gameOverTitle: 'انتهت الجولة',
  gameOverBody: (l) =>
      'وصلت إلى المستوى $l.\nالجولة الجديدة مجانية. حاول مرة أخرى!',
  goHome: 'الرئيسية',
  playAgain: 'العب مجدداً',
  victoryTitle: 'أحسنت!',
  victoryBody: (n) =>
      'أكملت المستويات المئة كلها\nوتعرّفت على $n لوناً من ألوان كرايولا!',
  settingsTitle: 'اللغة',
  languageLabel: 'اللغة',
  secondLanguageLabel: 'اللغة الثانية (للتعلّم)',
  secondLanguageHint: 'تظهر تحت اسم كل لون للمساعدة في تعلّم لغة جديدة.',
  none: 'بدون',
  done: 'تم',
);

final AppStrings _hi = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'अलग टाइल ढूँढो · Crayola रंग सीखो',
  start: 'खेल शुरू करें',
  bestLevel: (l) => 'रिकॉर्ड: स्तर $l',
  challenge: 'सभी 100 स्तर पार करो!',
  levelLabel: (l, m) => 'स्तर $l / $m',
  timeUp: '⏰ समय समाप्त!',
  wrongTap: '❌ गलत टाइल!',
  found: '🎉 मिल गया!',
  hint: '👆 अलग रंग वाली टाइल ढूँढो और उस पर टैप करो!',
  reviveTitle: '💔 जीवन खत्म!',
  reviveBody:
      'विज्ञापन देखकर 2 जीवन के साथ इसी स्तर से आगे खेलो।\n'
      'हर खेल में सिर्फ एक बार; विज्ञापन बीच में बंद करने पर नहीं मिलेगा।',
  giveUp: 'हार मानो',
  watchAd: 'विज्ञापन देखो',
  gameOverTitle: 'खेल समाप्त',
  gameOverBody: (l) =>
      'तुम स्तर $l तक पहुँचे।\nनया खेल मुफ्त है। फिर कोशिश करो!',
  goHome: 'होम',
  playAgain: 'फिर से खेलो',
  victoryTitle: 'कमाल कर दिया!',
  victoryBody: (n) => 'तुमने सभी 100 स्तर पार किए\nऔर $n Crayola रंग सीखे!',
  settingsTitle: 'भाषा',
  languageLabel: 'भाषा',
  secondLanguageLabel: 'दूसरी भाषा (सीखने के लिए)',
  secondLanguageHint: 'हर रंग के नाम के नीचे दिखती है ताकि नई भाषा सीख सको।',
  none: 'कोई नहीं',
  done: 'हो गया',
);

final AppStrings _id = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Temukan kotak yang beda · Belajar warna Crayola',
  start: 'Main',
  bestLevel: (l) => 'Rekor: level $l',
  challenge: 'Taklukkan semua 100 level!',
  levelLabel: (l, m) => 'Level $l / $m',
  timeUp: '⏰ Waktu habis!',
  wrongTap: '❌ Kotak salah!',
  found: '🎉 Ketemu!',
  hint: '👆 Cari kotak dengan warna berbeda lalu ketuk!',
  reviveTitle: '💔 Nyawa habis!',
  reviveBody:
      'Tonton iklan untuk hidup lagi dengan 2 nyawa dan lanjut dari level ini.\n'
      'Hanya satu kali per permainan; menutup iklan lebih awal tidak dihitung.',
  giveUp: 'Menyerah',
  watchAd: 'Tonton iklan',
  gameOverTitle: 'Permainan selesai',
  gameOverBody: (l) =>
      'Kamu mencapai level $l.\nPermainan baru gratis. Coba lagi!',
  goHome: 'Beranda',
  playAgain: 'Main lagi',
  victoryTitle: 'Berhasil!',
  victoryBody: (n) =>
      'Kamu menyelesaikan 100 level\ndan mengenal $n warna Crayola!',
  settingsTitle: 'Bahasa',
  languageLabel: 'Bahasa',
  secondLanguageLabel: 'Bahasa kedua (belajar)',
  secondLanguageHint:
      'Ditampilkan di bawah nama warna untuk membantu belajar bahasa baru.',
  none: 'Tidak ada',
  done: 'Selesai',
);

final AppStrings _th = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'หาช่องที่ไม่เหมือน · เรียนรู้สีเครโยลา',
  start: 'เริ่มเกม',
  bestLevel: (l) => 'สถิติ: ด่าน $l',
  challenge: 'พิชิตให้ครบ 100 ด่าน!',
  levelLabel: (l, m) => 'ด่าน $l / $m',
  timeUp: '⏰ หมดเวลา!',
  wrongTap: '❌ ผิดช่อง!',
  found: '🎉 เจอแล้ว!',
  hint: '👆 หาช่องที่สีไม่เหมือนแล้วแตะเลย!',
  reviveTitle: '💔 พลังชีวิตหมด!',
  reviveBody:
      'ดูโฆษณาเพื่อคืนชีพพร้อมพลังชีวิต 2 ดวง แล้วเล่นต่อจากด่านนี้\n'
      'คืนชีพได้ครั้งเดียวต่อเกม ปิดโฆษณากลางคันจะไม่นับ',
  giveUp: 'ยอมแพ้',
  watchAd: 'ดูโฆษณาเพื่อคืนชีพ',
  gameOverTitle: 'จบเกม',
  gameOverBody: (l) => 'คุณไปถึงด่าน $l\nเริ่มเกมใหม่ฟรี ลองอีกครั้งนะ!',
  goHome: 'หน้าหลัก',
  playAgain: 'เล่นอีกครั้ง',
  victoryTitle: 'เก่งมาก!',
  victoryBody: (n) => 'คุณผ่านครบ 100 ด่าน\nและรู้จักสีเครโยลา $n สีแล้ว!',
  settingsTitle: 'ภาษา',
  languageLabel: 'ภาษา',
  secondLanguageLabel: 'ภาษาที่สอง (เพื่อเรียนรู้)',
  secondLanguageHint: 'แสดงใต้ชื่อสีแต่ละสีเพื่อช่วยเรียนภาษาใหม่',
  none: 'ไม่มี',
  done: 'เสร็จ',
);

final AppStrings _vi = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Tìm ô khác màu · Học màu Crayola',
  start: 'Chơi',
  bestLevel: (l) => 'Kỷ lục: cấp $l',
  challenge: 'Chinh phục cả 100 cấp độ!',
  levelLabel: (l, m) => 'Cấp $l / $m',
  timeUp: '⏰ Hết giờ!',
  wrongTap: '❌ Sai ô rồi!',
  found: '🎉 Tìm thấy rồi!',
  hint: '👆 Tìm ô có màu khác và chạm vào nó!',
  reviveTitle: '💔 Hết mạng!',
  reviveBody:
      'Xem quảng cáo để hồi sinh với 2 mạng và chơi tiếp từ cấp này.\n'
      'Mỗi lượt chơi chỉ hồi sinh một lần; tắt quảng cáo giữa chừng sẽ không tính.',
  giveUp: 'Bỏ cuộc',
  watchAd: 'Xem quảng cáo hồi sinh',
  gameOverTitle: 'Kết thúc',
  gameOverBody: (l) =>
      'Bạn đã đến cấp $l.\nLượt chơi mới miễn phí. Thử lại nhé!',
  goHome: 'Trang chủ',
  playAgain: 'Chơi lại',
  victoryTitle: 'Bạn làm được rồi!',
  victoryBody: (n) =>
      'Bạn đã vượt qua cả 100 cấp độ\nvà làm quen với $n màu Crayola!',
  settingsTitle: 'Ngôn ngữ',
  languageLabel: 'Ngôn ngữ',
  secondLanguageLabel: 'Ngôn ngữ thứ hai (học tập)',
  secondLanguageHint: 'Hiển thị dưới tên mỗi màu để giúp học một ngôn ngữ mới.',
  none: 'Không',
  done: 'Xong',
);

final AppStrings _sv = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Hitta den avvikande rutan · Lär dig Crayola-färgerna',
  start: 'Spela',
  bestLevel: (l) => 'Rekord: nivå $l',
  challenge: 'Klara alla 100 nivåer!',
  levelLabel: (l, m) => 'Nivå $l / $m',
  timeUp: '⏰ Tiden är ute!',
  wrongTap: '❌ Fel ruta!',
  found: '🎉 Hittad!',
  hint: '👆 Hitta rutan med avvikande färg och tryck på den!',
  reviveTitle: '💔 Liven är slut!',
  reviveBody:
      'Titta på en reklam för att återupplivas med 2 liv och fortsätta från denna nivå.\n'
      'Bara en återupplivning per omgång; att stänga reklamen i förtid räknas inte.',
  giveUp: 'Ge upp',
  watchAd: 'Titta på reklam',
  gameOverTitle: 'Spelet är slut',
  gameOverBody: (l) =>
      'Du nådde nivå $l.\nEn ny omgång är gratis. Försök igen!',
  goHome: 'Hem',
  playAgain: 'Spela igen',
  victoryTitle: 'Du klarade det!',
  victoryBody: (n) =>
      'Du klarade alla 100 nivåer\noch lärde känna $n Crayola-färger!',
  settingsTitle: 'Språk',
  languageLabel: 'Språk',
  secondLanguageLabel: 'Andra språk (inlärning)',
  secondLanguageHint:
      'Visas under varje färgnamn för att hjälpa dig lära ett nytt språk.',
  none: 'Inget',
  done: 'Klar',
);

final AppStrings _da = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Find det anderledes felt · Lær Crayola-farverne',
  start: 'Spil',
  bestLevel: (l) => 'Rekord: bane $l',
  challenge: 'Klar alle 100 baner!',
  levelLabel: (l, m) => 'Bane $l / $m',
  timeUp: '⏰ Tiden er gået!',
  wrongTap: '❌ Forkert felt!',
  found: '🎉 Fundet!',
  hint: '👆 Find feltet med den anderledes farve og tryk på det!',
  reviveTitle: '💔 Ikke flere liv!',
  reviveBody:
      'Se en reklame for at genoplive med 2 liv og fortsætte fra denne bane.\n'
      'Kun én genoplivning pr. runde; at lukke reklamen før tid tæller ikke.',
  giveUp: 'Giv op',
  watchAd: 'Se reklame',
  gameOverTitle: 'Spillet er slut',
  gameOverBody: (l) => 'Du nåede bane $l.\nEn ny runde er gratis. Prøv igen!',
  goHome: 'Hjem',
  playAgain: 'Spil igen',
  victoryTitle: 'Du klarede det!',
  victoryBody: (n) =>
      'Du klarede alle 100 baner\nog lærte $n Crayola-farver at kende!',
  settingsTitle: 'Sprog',
  languageLabel: 'Sprog',
  secondLanguageLabel: 'Andet sprog (læring)',
  secondLanguageHint:
      'Vises under hvert farvenavn for at hjælpe med at lære et nyt sprog.',
  none: 'Intet',
  done: 'Færdig',
);

final AppStrings _no = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Finn ruten som skiller seg ut · Lær Crayola-fargene',
  start: 'Spill',
  bestLevel: (l) => 'Rekord: nivå $l',
  challenge: 'Klar alle 100 nivåer!',
  levelLabel: (l, m) => 'Nivå $l / $m',
  timeUp: '⏰ Tiden er ute!',
  wrongTap: '❌ Feil rute!',
  found: '🎉 Funnet!',
  hint: '👆 Finn ruten med en annen farge og trykk på den!',
  reviveTitle: '💔 Tomt for liv!',
  reviveBody:
      'Se en reklame for å gjenopplives med 2 liv og fortsette fra dette nivået.\n'
      'Bare én gjenoppliving per runde; å lukke reklamen for tidlig teller ikke.',
  giveUp: 'Gi opp',
  watchAd: 'Se reklame',
  gameOverTitle: 'Spillet er over',
  gameOverBody: (l) => 'Du nådde nivå $l.\nEn ny runde er gratis. Prøv igjen!',
  goHome: 'Hjem',
  playAgain: 'Spill igjen',
  victoryTitle: 'Du klarte det!',
  victoryBody: (n) =>
      'Du klarte alle 100 nivåer\nog ble kjent med $n Crayola-farger!',
  settingsTitle: 'Språk',
  languageLabel: 'Språk',
  secondLanguageLabel: 'Andrespråk (læring)',
  secondLanguageHint:
      'Vises under hvert fargenavn for å hjelpe deg å lære et nytt språk.',
  none: 'Ingen',
  done: 'Ferdig',
);

final AppStrings _fi = AppStrings(
  appTitle: 'Color Spot',
  tagline: 'Etsi erilainen ruutu · Opi Crayola-värit',
  start: 'Pelaa',
  bestLevel: (l) => 'Ennätys: taso $l',
  challenge: 'Selvitä kaikki 100 tasoa!',
  levelLabel: (l, m) => 'Taso $l / $m',
  timeUp: '⏰ Aika loppui!',
  wrongTap: '❌ Väärä ruutu!',
  found: '🎉 Löytyi!',
  hint: '👆 Etsi erivärinen ruutu ja napauta sitä!',
  reviveTitle: '💔 Elämät loppuivat!',
  reviveBody:
      'Katso mainos herätäksesi henkiin 2 elämällä ja jatkaaksesi tältä tasolta.\n'
      'Vain yksi herätys per peli; mainoksen sulkeminen kesken ei kelpaa.',
  giveUp: 'Luovuta',
  watchAd: 'Katso mainos',
  gameOverTitle: 'Peli päättyi',
  gameOverBody: (l) =>
      'Pääsit tasolle $l.\nUusi peli on ilmainen. Yritä uudelleen!',
  goHome: 'Koti',
  playAgain: 'Pelaa uudelleen',
  victoryTitle: 'Sinä teit sen!',
  victoryBody: (n) => 'Selvitit kaikki 100 tasoa\nja opit $n Crayola-väriä!',
  settingsTitle: 'Kieli',
  languageLabel: 'Kieli',
  secondLanguageLabel: 'Toinen kieli (oppiminen)',
  secondLanguageHint:
      'Näytetään jokaisen värin nimen alla auttamassa uuden kielen oppimisessa.',
  none: 'Ei mitään',
  done: 'Valmis',
);
