#!/usr/bin/env php
<?php
$buttons_src_gray = [
    "a" => file_get_contents("snes_button_a.svg"),
    "b" => file_get_contents("snes_button_b.svg"),
    "x" => file_get_contents("snes_button_x.svg"),
    "y" => file_get_contents("snes_button_y.svg"),
];

$colors = [
    "a" => "red",
    "b" => "yellow",
    "x" => "blue",
    "y" => "green",
];

foreach ($buttons_src_gray as $name => $src) {
    $buttons_src_color[$name] = str_replace(
        "lightgray",
        $colors[$name],
        $src
    );
    file_put_contents("snes_button_{$name}_color.svg", $buttons_src_color[$name]);
}

$viewbox = [0, 0, 0, 0, 0, 0];
foreach ($buttons_src_gray as $src) {
    preg_match('/viewBox="([^"]+)"/', $src, $matches);
    $v = explode(" ", $matches[1]);
    $viewbox[0] = min($viewbox[0], $v[0]);
    $viewbox[1] = min($viewbox[1], $v[1]);
    $viewbox[2] = max($viewbox[2], $v[2]);
    $viewbox[3] = max($viewbox[3], $v[3]);
    $viewbox[4] = max($viewbox[4], $v[2]);
    $viewbox[5] = max($viewbox[5], $v[3]);
}

$viewbox[0]--;
$viewbox[1]--;
$viewbox[2] = $viewbox[2] - $viewbox[0] + $viewbox[4];
$viewbox[2]++;
$viewbox[3] = $viewbox[3] - $viewbox[1] + $viewbox[5];
$viewbox[3]++;

unset($viewbox[4]);
unset($viewbox[5]);

$viewbox = implode(" ", $viewbox);

$t = explode("\n", $buttons_src_gray["a"]);
$prefix = [];
$prefix[] = array_shift($t);
$prefix[] = array_shift($t);
$prefix[] = array_shift($t);
$prefix[] = array_shift($t);

$prefix[2] = "<svg width=\"32mm\" height=\"32mm\" viewBox=\"$viewbox\" xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">";

$suffix = [];
$suffix[] = array_pop($t);
$suffix[] = array_pop($t);
$src_out = $buttons_src_gray["a"];

foreach ($colors as $colorname => $name) {
    $out = "";
    foreach ($prefix as $line) {
        $out .= $line . "\n";
    }
    $filename = "snes_button_$colorname-full.svg";
    foreach ($colors as $btn => $name) {
        $btn_src =
            $btn == $colorname
                ? $buttons_src_color[$btn]
                : $buttons_src_gray[$btn];
        $btn_src = explode("\n", $btn_src);
        array_shift($btn_src);
        array_shift($btn_src);
        array_shift($btn_src);
        array_shift($btn_src);
        array_pop($btn_src);
        array_pop($btn_src);
        $out .= implode("\n", $btn_src) . "\n";
    }
    foreach ($suffix as $line) {
        $out .= $line . "\n";
    }
    file_put_contents($filename, $out);
}

