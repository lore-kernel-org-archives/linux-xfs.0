Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AFEA47F4E
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 17:06:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 90B988F8087
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 15:06:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CZ3ogWFrtCdFSG15 for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 15:06:42 -0700 (PDT)
Date: Fri, 29 May 2015 08:06:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RESEND] xfs: fix kernel version in docs
Message-ID: <20150528220641.GB4316@dastard>
References: <CA+o=1OVKfP+MKFo1ZOj2E3_KfYLcQ+f0F1SoKYQNaApc2BREfA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+o=1OVKfP+MKFo1ZOj2E3_KfYLcQ+f0F1SoKYQNaApc2BREfA@mail.gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, May 27, 2015 at 04:54:06PM +0200, Fanael Linithien wrote:
> Linux v3.20 was released as v4.0.
> 
> Signed-off-by: Fanael Linithien <fanael4@gmail.com>
> ---
> Yes, it's a tiny docs change. As good a thing to start with as any.
> 
>  Documentation/filesystems/xfs.txt | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs.txt
> b/Documentation/filesystems/xfs.txt
> index 5a5a055..8146e9f 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -236,10 +236,10 @@ Removed Mount Options
> 
>    Name                Removed
>    ----                -------
> -  delaylog/nodelaylog        v3.20
> -  ihashsize            v3.20
> -  irixsgid            v3.20
> -  osyncisdsync/osyncisosync    v3.20
> +  delaylog/nodelaylog        v4.0
> +  ihashsize            v4.0
> +  irixsgid            v4.0
> +  osyncisdsync/osyncisosync    v4.0

Patch is whitespace mangled (i.e. converted tabs to spaces) and so
doesn't apply. I've fixed it up and applied it because it's a simple
patch, but it's best to initially send patches to yourself and try
to apply them to iron out problems like this in your patch sending
process.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
