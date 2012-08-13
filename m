Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7DB2dFh253724 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 06:02:39 -0500
Received: from mx4.geneon.de (76.reverse.geneon.de [89.244.16.76]) by
	cuda.sgi.com with ESMTP id PGEmC0VjmWT3ORcq for
	<xfs@oss.sgi.com>; Mon, 13 Aug 2012 04:02:34 -0700 (PDT)
From: Andreas Vogler <andreas.vogler@geneon.de>
Date: Mon, 13 Aug 2012 13:02:30 +0200
Subject: AW: bad version from xfs_repair after raid crash
Message-ID: <27CE2179D1925A4F9F4874725C3B4E0F0C5EFB6EBB@COSMOS.nbg.geneon.de>
References: <27CE2179D1925A4F9F4874725C3B4E0F0C5EFB6E94@COSMOS.nbg.geneon.de>
	<5026D290.10209@sandeen.net>
	<27CE2179D1925A4F9F4874725C3B4E0F0C5EFB6E98@COSMOS.nbg.geneon.de>
	<20120812213719.GI2877@dastard>
In-Reply-To: <20120812213719.GI2877@dastard>
Content-Language: de-DE
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> So, yeah, upgrade your userspace to something recent, and it will just work.

Ok, the most recent xfs_repair doesn't complain about the version and at least starts repairing even though the system seems extremely corrupt. Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
