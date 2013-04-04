Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 478297F3F
	for <xfs@oss.sgi.com>; Thu,  4 Apr 2013 06:59:39 -0500 (CDT)
Message-ID: <515D6B3C.5070104@sgi.com>
Date: Thu, 4 Apr 2013 06:59:56 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] cleanup duplicates in all tests
References: <20130403173245.376605011@sgi.com>
In-Reply-To: <20130403173245.376605011@sgi.com>
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
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Thanks for the review Eric, this patch has been committed.

--Rich

commit 0efd4f4d483a725212f531bc2ed964de2766b1cd
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Wed Apr 3 17:31:49 2013 +0000

     xfstests: cleanup duplicates in all tests

     There are duplicate blank lines, comment hash and lines
     containing duplicate seqres= declarations, remove them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
