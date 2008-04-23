Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 23:20:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3N6KO32026652
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 23:20:27 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA14839 for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 16:21:04 +1000
Date: Wed, 23 Apr 2008 16:22:18 +1000
Subject: xfsprogs 2.9.8 source tarball released
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.t91vzgbk3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs_2.9.8-1.tar.gz

Changes since 2.9.7:

         - Add support for sb_features2 in wrong location in mkfs.xfs,
           xfs_repair and xfs_db.
         - Improve memory limits for libxfs cache in xfs_repair and added
           a -m option to manually limit usage of xfs_repair.
         - Add -c option to xfs_admin to turn lazy-counters on/off.
         - Added support for mdp in libdisk/mkfs.xfs, thanks to
           Hubert Verstraete.
         - Add -p option to fsck.xfs, thanks to Markus Rothe.
         - Cleanup sys v3 bzero/bcopy calls, thanks to Nigel Kukard.
