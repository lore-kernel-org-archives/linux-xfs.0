Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n082LLmX025702 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 20:21:21 -0600
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91EE86E2BF
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 18:21:21 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.246]) by cuda.sgi.com with ESMTP id
	IIpkfr0WDYnOQXoT for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 18:21:21 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id f25so8074933rvb.32
	for <xfs@oss.sgi.com>; Wed, 07 Jan 2009 18:21:21 -0800 (PST)
Message-Id: <20090108021947.404730068@ifup.org>
Date: Wed, 07 Jan 2009 18:19:47 -0800
From: brandon@ifup.org
Subject: [patch 0/4] attr: test/ improvements and integrate with make
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
To: xfs@oss.sgi.com

Hello-

NOTE: Timothy Shimmin's email (tes@sgi.com) seems to be gone. Who should
I send patches like this to in the future?

This series makes some improvements to the attr tests to integrate them
into make and add a few testing features to the harness.

The most useful feature is being able to run `make test` from the root
of the source tree to build the tree to run a generic set of tests.

Cheers,

       Brandon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
