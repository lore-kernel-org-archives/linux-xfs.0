Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9C2C47F3F
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 09:55:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6E7A58F8089
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 07:55:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id NkYeP5E5SKOi6te0 for <xfs@oss.sgi.com>;
	Sat, 23 Mar 2013 07:55:24 -0700 (PDT)
Message-ID: <514DC25A.3070507@sandeen.net>
Date: Sat, 23 Mar 2013 09:55:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix the seq number in README
References: <1364045391-28476-1-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1364045391-28476-1-git-send-email-zwu.kernel@gmail.com>
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
To: zwu.kernel@gmail.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

On 3/23/13 8:29 AM, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Although it is one very trivial bug, one patch is worth to
> make it perfect.
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

easy one ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  README | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/README b/README
> index b70f75d..2d231de 100644
> --- a/README
> +++ b/README
> @@ -177,7 +177,7 @@ Test script environment:
>  				  and the content of the NIS database
>  				  if it is likely to be present)
>  
> -     4. General recommendations, usage conventions, etc.:
> +     5. General recommendations, usage conventions, etc.:
>  	- When the content of the password or group file is
>  	  required, get it using the _cat_passwd and _cat_group
>  	  functions, to ensure NIS information is included if NIS
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
