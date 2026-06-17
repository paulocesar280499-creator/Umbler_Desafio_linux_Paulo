<?php
//Paulo cesar
$db_host = getenv('DB_HOST') ?: 'mariadb';
$db_name = getenv('DB_NAME') ?: 'appdb';
$db_user = getenv('DB_USER') ?: 'appuser';
$db_pass = getenv('DB_PASS') ?: 'secret';

$db_status = 'Não testado';
$db_class  = 'warning';

try {
    $pdo = new PDO(
        "mysql:host={$db_host};dbname={$db_name};charset=utf8mb4",
        $db_user,
        $db_pass,
        [PDO::ATTR_TIMEOUT => 3]
    );
    $version = $pdo->query('SELECT VERSION()')->fetchColumn();
    $db_status = "✔ Conectado — MariaDB $version";
    $db_class  = 'success';
} catch (PDOException $e) {
    $db_status = "✖ Erro: " . $e->getMessage();
    $db_class  = 'error';
}
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Umbler — Teste Paulo Cesar Santos De Jesus Junior</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 900px; margin: 40px auto; padding: 0 20px; }
    .badge { padding: 8px 16px; border-radius: 4px; display: inline-block; margin: 4px; }
    .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .warning { background: #fff3cd; color: #856404; border: 1px solid #ffc107; }
    .error   { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    hr { margin: 30px 0; }
  </style>
</head>
<body>
  <h1>Foi um prazer realizar o teste, espero que possamos bate um papo para comprova meu conhecimento abraçosr</h1>
  <p>Stack: <strong>Nginx + PHP-FPM + MariaDB</strong> via Docker Compose</p>

  <h2>Status dos Serviços</h2>
  <div class="badge success">✔ PHP <?= PHP_VERSION ?></div>
  <div class="badge <?= $db_class ?>"><?= htmlspecialchars($db_status) ?></div>

  <hr>
  <h2>PHP Info</h2>
  <?php phpinfo(); ?>
</body>
</html>
