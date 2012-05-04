Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44L3nAg089033 for <xfs@oss.sgi.com>; Fri, 4 May 2012 16:03:49 -0500
Date: Fri, 4 May 2012 16:07:13 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/4] xfstests: Add the new test to the group file
Message-ID: <20120504210713.GY16881@sgi.com>
References: <20120221165833.23253.38042.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120221165857.23253.15762.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120221165857.23253.15762.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 21, 2012 at 10:58:57AM -0600, Chandra Seetharaman wrote:
> >From 16e62fe191e58cd45130376866b779cad2e56683 Mon Sep 17 00:00:00 2001
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> Date: Tue, 21 Feb 2012 09:33:39 -0600
> Subject: [PATCH 4/4] Add the new test 276 to the group file.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  group |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/group b/group
> index 08d999a..f39c303 100644
> --- a/group
> +++ b/group
> @@ -389,3 +389,4 @@ deprecated
>  273 auto rw
>  274 auto rw
>  275 auto rw
> +276 quota auto quick

I suggest you just roll this into patch 3.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
