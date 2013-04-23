Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D598D7F37
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 08:55:07 -0500 (CDT)
Message-ID: <517692C7.40402@sgi.com>
Date: Tue, 23 Apr 2013 08:55:19 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: capture the failure result of 310
References: <5175FC5C.5020607@huawei.com>
In-Reply-To: <5175FC5C.5020607@huawei.com>
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
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Thanks for submitting this patch, it has been committed.

--Rich

commit 45ed7bb0a4b6cb9562becc28ac0964e40b44bc97
Author: Zhao Hongjiang <zhaohongjiang@huawei.com>
Date:   Tue Apr 23 03:13:32 2013 +0000

     xfstests: capture the failure result of 310

     Capture the failure by the way of counting dmesg errors and describe
     how the test triggers problems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
