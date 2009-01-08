Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0828xiC024412 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 20:09:00 -0600
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC5D317B9611
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 18:08:58 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com
	[209.85.146.180]) by cuda.sgi.com with ESMTP id
	uT6KpfrH4in0a3Zn for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 18:08:58 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id j5so4886607wah.4
	for <xfs@oss.sgi.com>; Wed, 07 Jan 2009 18:08:58 -0800 (PST)
Message-Id: <20090108015355.613058570@ifup.org>
Date: Wed, 07 Jan 2009 17:53:55 -0800
From: brandon@ifup.org
Subject: [patch 0/5] acl: test/ improvements and integrate with make
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: tes@sgi.com
Cc: xfs@oss.sgi.com

Hello-

This series makes some improvements to the acl tests to integrate them
into make and add a few testing features to the harness.

The most useful feature is being able to run `make test` from the root
of the source tree to build the tree to run a generic set of tests.

Cheers,

	Brandon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
