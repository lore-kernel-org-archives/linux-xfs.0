Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n54EkgbC249273 for <xfs@oss.sgi.com>; Thu, 4 Jun 2009 09:46:42 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A07AF1055CAF
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2009 07:53:38 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id FjmycVdLE6FUYHGb for
	<xfs@oss.sgi.com>; Thu, 04 Jun 2009 07:53:38 -0700 (PDT)
Message-ID: <4A27DE61.5030704@sandeen.net>
Date: Thu, 04 Jun 2009 09:46:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] [XFSQA] Add license boilerplate to 205
References: <20090604091558.GS16929@discord.disaster>
In-Reply-To: <20090604091558.GS16929@discord.disaster>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> [XFSQA] Add license boilerplate to 205
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

looks good to me :)

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Thanks Dave.

> ---
>  205 |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/205 b/205
> index 502adc7..c85e102 100755
> --- a/205
> +++ b/205
> @@ -5,6 +5,19 @@
>  #
>  #-----------------------------------------------------------------------
>  # Copyright (c) 2009 Dave Chinner
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>  #-----------------------------------------------------------------------
>  #
>  # creator
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
