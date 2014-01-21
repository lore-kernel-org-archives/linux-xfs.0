Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D11AD29DF8
	for <xfs@oss.sgi.com>; Tue, 21 Jan 2014 05:43:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE1DB304043
	for <xfs@oss.sgi.com>; Tue, 21 Jan 2014 03:43:26 -0800 (PST)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id dvx6UZdVekc0q1BB (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Jan 2014 03:43:25 -0800 (PST)
Subject: Bug#725971: reuse this issue for the more general solution to use
	dh-autoreconf
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.725971.B725971.139030442926917@bugs.debian.org>
From: Matthias Klose <doko@debian.org>
Message-Id: <E1W5Zgz-0003yG-Gp@ravel.debian.org>
Date: Tue, 21 Jan 2014 11:40:29 +0000
Reply-To: Matthias Klose <doko@debian.org>, 725971@bugs.debian.org
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: 725971@bugs.debian.org

Control: retitle -1 xfsprogs: run dh-autoreconf to update config.{sub,guess} and {libtool,aclocal}.m4

Reusing this report for the more general solution to also update
the libtool.m4 and/or aclocal.m4 files, needed for the port mentioned
in bug #726404.

See https://wiki.debian.org/qa.debian.org/FTBFS for a guide how to
address these.

Please ignore this email if the libtool.m4/aclocal.m4 update is not
needed, and updating the config.{guess,sub} files is sufficient.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
