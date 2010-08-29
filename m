Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7TKsnom226978 for <xfs@oss.sgi.com>; Sun, 29 Aug 2010 15:54:50 -0500
Received: from smtpo07.poczta.onet.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8200C1789E40
	for <xfs@oss.sgi.com>; Sun, 29 Aug 2010 13:55:22 -0700 (PDT)
Received: from smtpo07.poczta.onet.pl (smtpo07.poczta.onet.pl
	[213.180.142.138]) by cuda.sgi.com with ESMTP id
	3nGo5690SDHBQutI for <xfs@oss.sgi.com>;
	Sun, 29 Aug 2010 13:55:22 -0700 (PDT)
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:45478 "EHLO
	orion.wszechswiat.org" rhost-flags-OK-OK-OK-FAIL) by ps2.m5r2.onet
	with ESMTPSA id S134218389Ab0H2JU2116YF (ORCPT
	<rfc822;xfs@oss.sgi.com>); Sun, 29 Aug 2010 11:20:28 +0200
Message-ID: <4C7A2654.3080106@op.pl>
Date: Sun, 29 Aug 2010 11:20:20 +0200
From: Bogdan <bogdandr@op.pl>
MIME-Version: 1.0
Subject: xfsprogs: minimum version with these commands
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

 Hello.

 I couldn't find this information in the xfsprogs ChangeLog, so I'm
asking here: what is the minimum version of xfsprogs to:

1) contain these utilities: xfs_db, xfs_freeze, xfs_check, and
2) xfs_db accepts the following command-line parameters: -i, -c, and
3) xfs_freeze accepts the following command-line parameters: -f, -u, and
4) xfs_db accepts the following interactive mode commands: "freesp
-d", "quit", "blockget -n", "ncheck", "sb 0", "print".

 Or is there a ChangeLog that covers all xfsprogs versions in such
deatil that I would be able to find this myself? If so, where can I
find it?

-- 
Pozdrawiam/Regards - Bogdan                     (GNU/Linux & FreeDOS)
Kurs asemblera x86 (DOS, GNU/Linux):http://rudy.mif.pg.gda.pl/~bogdro
Grupy dyskusyjne o asm:  pl.comp.lang.asm alt.pl.asm alt.pl.asm.win32
www.Xiph.org   www.TorProject.org   Soft (EN): miniurl.pl/bogdro-soft

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
