Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4P7IpjC044199 for <xfs@oss.sgi.com>; Fri, 25 May 2012 02:18:51 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id Z1ci5iAovM6Zx1Y7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 00:18:49 -0700 (PDT)
From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 6/6] Update .gitignore
Date: Fri, 25 May 2012 09:18:43 +0200
Message-Id: <1337930323-575-7-git-send-email-jengelh@inai.de>
In-Reply-To: <1337930323-575-1-git-send-email-jengelh@inai.de>
References: <1337930323-575-1-git-send-email-jengelh@inai.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jengelh@inai.de

Root entries to where they only can occur.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 .gitignore |   82 ++++++++++++++++++++++++++++++------------------------------
 1 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/.gitignore b/.gitignore
index 22b4f65..525b9b7 100644
--- a/.gitignore
+++ b/.gitignore
@@ -5,64 +5,64 @@
 
 # build system
 .census
-include/platform_defs.h
-include/builddefs
-install-sh
+/include/platform_defs.h
+/include/builddefs
+/install-sh
 
 # magic directory symlinks
-include/disk
-include/xfs
+/include/disk
+/include/xfs
 
 # packaging
-doc/CHANGES.gz
-xfsprogs-*
-xfsprogs_*
-xfslibs-dev_*
+/doc/CHANGES.gz
+/xfsprogs-*
+/xfsprogs_*
+/xfslibs-dev_*
 
 # autoconf generated files
-aclocal.m4
-m4/libtool.m4
-m4/ltoptions.m4
-m4/ltsugar.m4
-m4/ltversion.m4
-m4/lt~obsolete.m4
-autom4te.cache/
-config.guess
-config.log
-config.status
-config.sub
-configure
+/aclocal.m4
+/m4/libtool.m4
+/m4/ltoptions.m4
+/m4/ltsugar.m4
+/m4/ltversion.m4
+/m4/lt~obsolete.m4
+/autom4te.cache/
+/config.guess
+/config.log
+/config.status
+/config.sub
+/configure
 
 # libtool
-libtool
-ltmain.sh
+/libtool
+/ltmain.sh
 *.lo
 *.la
 .libs
 
 # gettext
-po/de.mo
-po/pl.mo
-po/xfsprogs.pot
+/po/de.mo
+/po/pl.mo
+/po/xfsprogs.pot
 
 # cscope stuff
 cscope.*
 
 # quilt stuff
-.pc/
-patches/
+/.pc/
+/patches/
 
 # binaries
-copy/xfs_copy
-db/xfs_db
-estimate/xfs_estimate
-fsr/xfs_fsr
-growfs/xfs_growfs
-io/xfs_io
-logprint/xfs_logprint
-mdrestore/xfs_mdrestore
-mkfs/fstyp
-mkfs/mkfs.xfs
-quota/xfs_quota
-repair/xfs_repair
-rtcp/xfs_rtcp
+/copy/xfs_copy
+/db/xfs_db
+/estimate/xfs_estimate
+/fsr/xfs_fsr
+/growfs/xfs_growfs
+/io/xfs_io
+/logprint/xfs_logprint
+/mdrestore/xfs_mdrestore
+/mkfs/fstyp
+/mkfs/mkfs.xfs
+/quota/xfs_quota
+/repair/xfs_repair
+/rtcp/xfs_rtcp
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
