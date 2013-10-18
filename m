Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 49B807F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 16:29:53 -0500 (CDT)
Message-ID: <5261A84B.6010006@sgi.com>
Date: Fri, 18 Oct 2013 16:29:47 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfsdump: avoid segfault in partial_reg() in error case
References: <525480A6.3000202@redhat.com> <525481C2.6040100@sandeen.net>
In-Reply-To: <525481C2.6040100@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

This has been committed.

Thanks
--Rich

commit 1162bdbcff77ed2341f0a9294db76df80f2f36a3
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Oct 8 22:05:54 2013 +0000

     xfsdump: avoid segfault in partial_reg() in error case

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
