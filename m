Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NEKRun060441 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 09:20:27 -0500
Message-ID: <5086A86C.5090107@sgi.com>
Date: Tue, 23 Oct 2012 09:23:40 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] respect DESTDIR when installing
References: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
	<1348529978-30048-2-git-send-email-vapier@gentoo.org>
	<20120925094139.GK9189@infradead.org>
	<201210190021.59105.vapier@gentoo.org>
	<20121023122546.GD7341@infradead.org>
In-Reply-To: <20121023122546.GD7341@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Frysinger <vapier@gentoo.org>, xfs@oss.sgi.com

On 10/23/2012 07:25 AM, Christoph Hellwig wrote:
> On Fri, Oct 19, 2012 at 12:21:58AM -0400, Mike Frysinger wrote:
>> On Tuesday 25 September 2012 05:41:39 Christoph Hellwig wrote:
>>> Looks good.  I guess this is for xfstests as it should be working for
>>> the real tools?
>>
>> hmm, these don't appear to have been merged.  is there something i should do ?
>
> No, but I stopped applying patches to the kernel.org repos, with the SGI
> people pickingup the slack using the oss.sgi.com repos.
>
> Ben, any chance you could re-review the series and apply it?
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
Mike/Christoph,

I am in the process of going through patchworks and cleaning up the 
list.  I will make sure to include this.

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
