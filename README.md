- Hyper-V, VirtualBox, VMWare のパフォーマンスの差
- docker for Windows と docker Toolbox のパフォーマンスの差
- ファイルの同期方法によるパフォーマンスの差
	- virtualbox
	- smb
	- reverse-smb
	- rsync
	- nfs
	- unison


# 仮想環境のランタイム実行速度テスター

## 背景

- 依存パッケージのインストール(composer)
- ユニットテスト(phpunit)

開発効率化に関わる仮説の一つとして、「個人仮想環境でのランタイム実行速度が遅いと、開発効率も下がる」と考えた。

そこで、今回は個人仮想環境でのランタイム実行速度が、「仮想環境の種類」によって違いがあるのではないかという点に絞って考察してみることにした。

## 計測方法

環境の設定は、社内で最も利用されている `vagrant` 、ランタイム実行速度は [laravel/framework v5.6.22](https://github.com/laravel/framework/tree/v5.6.22) の composer 及び phpunit を利用する。

また、複数の環境で同じテストが行えるよう、 `bash` スクリプトを使って自動化する。

※事前に各種仮想環境が **同じディスクを利用していることを** 確認してください

## 計測指標

- `fio` コマンドによるIOベンチマーク
- `composer install` にかかった時間
- `phpunit` にかかった時間

## 計測マシン

### 計測マシンA(Windows 10)

家PC、ここにスペック

- Hyper-V(win10-hyperv.bash)
- VirtualBox(win10-virtualbox.bash)
- Native(win10-native.bash)
- WSL Ubuntu 18.04(win10-wsl.bash)
- WSL Ubuntu 18.04 with No Defender(win10-wsl-no-defender.bash)

### 計測マシンB(macOS High Sierra)

MacBookAir ここにスペック

- VirtualBox(mac-virtualbox.bash)
- libvirt(mac-libvirt.bash)
- Native(mac-native.bash)

### 計測マシンC(Ubuntu 18.04)

会社Ubuntu 18.04 ここにスペック

- VirtualBox(ubuntu-virtualbox.bash)
- libvirt(ubuntu-libvirt.bash)
- Native(ubuntu-native.bash)

---

### 他にやりたいもの

- vagrant の synced_folder の種類によって実行速度が変わるか
    - ホストOSでリポジトリ操作を行いたい場合の、ゲスト側の実行速度の変化
- unison による手動同期の可能性
- サンプルLAMPアプリケーションに対して Chrome driver を使った自動テストにかかる時間の計測
- Windows Defender を OFF にした場合の計測
- VMWare も計測したいけど別に計測以外で使う用途ないしなあ
- docker の種類によってphpunit速度が変わるか(こっちはvagrant関係なし)
    - docker for Windows(=Hyper-V),  Docker Toolbox(=VirtualBox), docker for Mac, docker Native