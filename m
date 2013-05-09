Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FE9129DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 14:47:53 -0500 (CDT)
Message-ID: <518BFD56.9080605@sgi.com>
Date: Thu, 9 May 2013 14:47:34 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add execution of a custom command to fsstress
	(-x and -X options)
References: <1363863585-25598-1-git-send-email-list.xfs@jan-o-sch.net>
	<20130321195054.GO17758@dastard> <514B72B9.1010005@jan-o-sch.net>
	<20130321211218.GP17758@dastard> <514C0309.1000104@jan-o-sch.net>
	<20130324235135.GH6369@dastard> <515EBE9E.3000905@jan-o-sch.net>
	<5183CCFB.8060505@jan-o-sch.net>
In-Reply-To: <5183CCFB.8060505@jan-o-sch.net>
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
To: Jan Schmidt <list.xfs@jan-o-sch.net>
Cc: xfs@oss.sgi.com

On 05/03/2013 09:43 AM, Jan Schmidt wrote:

>
> Looks like there are no suggestions how to make -x useful for multiple workers.
> Can we then have the single worker solution (original patch) merged for now?
>
> -Jan

I don't see why not.  Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
