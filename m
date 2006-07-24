Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 07:42:10 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.184])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6OEfxDW010263
	for <linux-xfs@oss.sgi.com>; Mon, 24 Jul 2006 07:41:59 -0700
Received: by nf-out-0910.google.com with SMTP id a27so1547302nfc
        for <linux-xfs@oss.sgi.com>; Mon, 24 Jul 2006 07:41:35 -0700 (PDT)
Message-ID: <d1ec67b40607240625s5d8b9385ueab714c0f20fcc24@mail.gmail.com>
Date: Mon, 24 Jul 2006 15:25:09 +0200
From: "Artur Iwaniuk" <aiwaniuk@gmail.com>
Subject: atime on xfs
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

hello,

can anyone can me explain such stat on my xfs partition:

  File: `194/194.149.231.137'
  Size: 0               Blocks: 0          IO Block: 4096   pusty zwyk=B3y
plik
Device: 902h/2306d      Inode: 1477457428  Links: 1
Access: (0666/-rw-rw-rw-)  Uid: (  201/  qmaild)   Gid: (  200/ nofiles)
Access: 2006-07-18 09:13:32.903206500 +0200
Modify: 2006-07-18 11:26:23.273786250 +0200
Change: 2006-07-18 11:26:23.273786250 +0200

why access time is earlier than change, modify time ? how is it posible? is
there bug in xfs ?
i am sure, that file was asscessed yesterday, maybe even today

please, help


[[HTML alternate version deleted]]
