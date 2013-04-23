Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C767C7F37
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 08:32:54 -0500 (CDT)
Message-ID: <51768D8E.2060207@sgi.com>
Date: Tue, 23 Apr 2013 08:33:02 -0500
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

Thanks for making the suggested changes.

FYI it helps the review process if you include a version log below the 
header something like.

   Capture the failure by the way of counting dmesg errors and describe
   how the test triggers problems.

   Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
   [eguan@redhat.com fix common file path and other cleanups]

   ---
   V1:
	Initial version

   V2:
	Added suggestions from xxx@somewhere.org to fix something
	Reworked logic for function blah

Minor description change, other than that, it looks good.

--Rich

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
