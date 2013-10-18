Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C08097F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:39:25 -0500 (CDT)
Message-ID: <52617249.4030701@sgi.com>
Date: Fri, 18 Oct 2013 12:39:21 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: Bug#725971: xfsprogs: config.guess/config.sub out of date for
	arm64
References: <20131010133811.GK32337@riva.ucam.org>	<408976477.5626180.1381447471755.JavaMail.root@redhat.com>
	<1803090820.5630526.1381449379093.JavaMail.root@redhat.com>
In-Reply-To: <1803090820.5630526.1381449379093.JavaMail.root@redhat.com>
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
To: Nathan Scott <nathans@debian.org>, XFS <xfs@oss.sgi.com>

Please submit as a patch with a new subject next time ;)

commit 5b962abcbb952e5409e2b2a1ecbc71b5d370cdea
Author: Nathan Scott <nathans@debian.org>
Date:   Thu Oct 10 23:56:19 2013 +0000

     xfsprogs: fix a warning in the deb build

     Fixes a warning in the deb build for me, plus some trivial cleanup
     in the release script.

     Signed-off-by: Nathan Scott <nathans@debian.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>


On 10/10/2013 06:56 PM, Nathan Scott wrote:
>
> ----- Original Message -----
>> ...
>> Have tested this out here & works just fine - please merge.
>>
>
> Also, the attached fixes a warning in the deb build for me,
> plus some trivial cleanup in the release script.
>
> cheers.
>
> --
> Nathan
>
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
