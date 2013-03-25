Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DDB6A7F50
	for <xfs@oss.sgi.com>; Mon, 25 Mar 2013 08:52:39 -0500 (CDT)
Message-ID: <515056A8.8000408@sgi.com>
Date: Mon, 25 Mar 2013 08:52:40 -0500
From: Rich Johnston <rjohnston@sgi.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: zwu.kernel@gmail.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

On 03/23/2013 08:29 AM, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
>    Although it is one very trivial bug, one patch is worth to
> make it perfect.
>
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>   README | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/README b/README
> index b70f75d..2d231de 100644
> --- a/README
> +++ b/README
> @@ -177,7 +177,7 @@ Test script environment:
>   				  and the content of the NIS database
>   				  if it is likely to be present)
>
> -     4. General recommendations, usage conventions, etc.:
> +     5. General recommendations, usage conventions, etc.:
>   	- When the content of the password or group file is
>   	  required, get it using the _cat_passwd and _cat_group
>   	  functions, to ensure NIS information is included if NIS
>

Proper documentation is important thanks for the patch.
This patch has been committed.

Thanks
--Rich

commit dd1ee061a8784520287a7847c3404d719f46c854
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Sat Mar 23 13:29:51 2013 +0000

     xfstests: fix the seq number in README


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
