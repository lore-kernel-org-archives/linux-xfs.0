Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 01D507F50
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 03:39:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E1BC9304084
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 01:39:18 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id B6981cFPqn1agco9 for
	<xfs@oss.sgi.com>; Thu, 28 Mar 2013 01:39:17 -0700 (PDT)
Date: Thu, 28 Mar 2013 04:39:09 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <89410478.7664777.1364459949523.JavaMail.root@redhat.com>
In-Reply-To: <20130312074608.GL21651@dastard>
Subject: Re: 3.9-rc2 xfs panic
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

FYI, I never saw any of those issues on testing any longer after
switched to use real storage devices rather than loopback ones.
I have changed the tests to always use real ones since then.

CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
