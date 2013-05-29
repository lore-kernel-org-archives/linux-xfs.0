Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B6897F50
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 08:19:08 -0500 (CDT)
Message-ID: <51A60080.4080002@sgi.com>
Date: Wed, 29 May 2013 08:20:00 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix typo in check
References: <1369072319-13738-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1369072319-13738-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On 05/20/2013 12:51 PM, Eryu Guan wrote:
> There is no $testname, should be $test_name
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Thanks, this patch has been committed:

commit 38d58591fc0607bfd262fc8d363e52047fcf0e9c
Author: Eryu Guan <eguan@redhat.com>
Date:   Wed May 29 08:12:44 2013 -0500

     xfstests: fix typo in check

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
