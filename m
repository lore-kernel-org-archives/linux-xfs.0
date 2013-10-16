Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E95107F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 15:25:38 -0500 (CDT)
Message-ID: <525EF661.4020907@sgi.com>
Date: Wed, 16 Oct 2013 15:26:09 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfstests: restrict 259 device sizes to multiples of 512
References: <5250CA13.8040006@redhat.com> <5250CC9B.50807@sandeen.net>
	<5250CD80.9090708@sandeen.net>
In-Reply-To: <5250CD80.9090708@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

This has been committed.

Thanks
--Rich

commit aaac93cb801e733af92c531c4f0aebac337ee7b8
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sun Oct 6 02:40:00 2013 +0000

     xfstests: restrict 259 device sizes to multiples of 512


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
