Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 80A5B7F53
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 23:07:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F4005AC001
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 21:07:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 2aXePdr9u4hadst4 for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 21:07:14 -0700 (PDT)
Message-ID: <534A0D72.10304@sandeen.net>
Date: Sat, 12 Apr 2014 23:07:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] generic/022: update expected output after the test
	was renamed
References: <1397343317-14669-1-git-send-email-tytso@mit.edu>
	<1397343317-14669-3-git-send-email-tytso@mit.edu>
In-Reply-To: <1397343317-14669-3-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com
Cc: Lukas Czerner <lczerner@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>

On 4/12/14, 5:55 PM, Theodore Ts'o wrote:
> After generic/022 was renamed by commit 21723cdb, the wrong test
> number was put into generic/022.out.  Fix this.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Lukas Czerner <lczerner@redhat.com>

Lukas sent this a couple days ago as well.

In any case, again, Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/generic/022.out | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/022.out b/tests/generic/022.out
> index 96c2d33..fbffa59 100644
> --- a/tests/generic/022.out
> +++ b/tests/generic/022.out
> @@ -1,4 +1,4 @@
> -QA output created by 009
> +QA output created by 022
>  	1. into a hole
>  f4f35d60b3cc18aaa6d8d92f0cd3708a
>  	2. into allocated space
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
