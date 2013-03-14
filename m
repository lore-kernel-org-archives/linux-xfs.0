Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EBDBC7F95
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 15:12:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 689EDAC009
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 13:12:13 -0700 (PDT)
Date: Thu, 14 Mar 2013 17:12:07 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 01/18] xfstests: Remove obsolete remake script
Message-ID: <20130314201207.GA32283@andromeda.usersys.redhat.com>
References: <20130314130611.405A853DEAEF@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130314130611.405A853DEAEF@polaris-admin.engr.sgi.com>
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
To: Philip White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 14, 2013 at 06:06:11AM -0700, Philip White wrote:
> From: Phil White <pwhite@sgi.com>
> 
> 
> This is a rebasing & resubmit of a dchinner patch.  His comments on the
> original:
> -----------------
> We don't ever do wholesale rebuilds of the output files anymore, so
> kill the script that does it to reduce the dependency on common and
> common.rc.
> -----------------
> 
> Signed-off-by: Phil White <pwhite@sgi.com>
> ---
>  remake |   72 ----------------------------------------------------------------
>  1 files changed, 0 insertions(+), 72 deletions(-)
>  delete mode 100755 remake
> 
> diff --git a/remake b/remake
> deleted file mode 100755
> index a95aae7..0000000
> --- a/remake
> +++ /dev/null
Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
