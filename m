Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A38237F37
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 13:21:35 -0500 (CDT)
Message-ID: <519280CB.9020606@sgi.com>
Date: Tue, 14 May 2013 13:22:03 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfstests: remove fio config files after finished test
References: <1368346884-31264-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1368346884-31264-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 05/12/2013 03:21 AM, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> After finished test, temporarily fio config file should be removed.
> This commit tries to fix this problem in the following test cases:
>    - generic/299-300
>    - ext4/301-304
>    - shared/305
>

This has been committed:

commit 05aab5cf04e791eb5e85c00722a721909f6c0ae0
Author: Zheng Liu <wenqing.lz@taobao.com>
Date:   Tue May 14 08:35:44 2013 -0500

     xfstests: remove fio config files after finished test

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
