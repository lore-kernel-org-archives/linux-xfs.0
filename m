Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LJ806M170676 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 14:08:01 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 0/5] xfstests: dmapi: eliminate all build warnings
Date: Thu, 21 Apr 2011 14:11:08 -0500
Message-Id: <1303413073-24173-1-git-send-email-aelder@sgi.com>
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

I'm hoping the Nth time is a charm...

This series eliminates all build warnings that come out of building
things under the dmapi/ subdirectory.  I'm using gcc 4.x (x < 6) on
several platforms, including i386, x86_64, and ia64 architectures.

I have sent these a couple times before; they are unmodified from
the last time I sent them out.  I am omitting the summary of the
types of warnings and how they got resolved this time around.

                                        -Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
