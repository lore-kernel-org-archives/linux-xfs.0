Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E1C47F58
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 10:48:23 -0500 (CDT)
Message-ID: <521F6D45.7060100@sgi.com>
Date: Thu, 29 Aug 2013 10:48:21 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: _test_generic_punch: Obtain block size from
	$TEST_DIR
References: <2632380.gCujKLhaaV@localhost.localdomain>
In-Reply-To: <2632380.gCujKLhaaV@localhost.localdomain>
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
To: chandan <chandan@linux.vnet.ibm.com>
Cc: xfs@oss.sgi.com

Thanks for the patch Chadan, it has been committed.

--Rich

commit f6406daca8a91216019e62c8924c171e8a414d05
Author: chandan <chandan@linux.vnet.ibm.com>
Date:   Wed Aug 28 06:24:10 2013 +0000

     xfstests: _test_generic_punch: Obtain block size from $TEST_DIR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
