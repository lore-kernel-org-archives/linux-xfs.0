Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5308029DF7
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2014 08:34:13 -0500 (CDT)
Message-ID: <533428D6.507@sgi.com>
Date: Thu, 27 Mar 2014 08:34:14 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs errors while unlinking filenames with hash collisions
References: <20140327074156.GJ29498@order.stressinduktion.org>
	<5334241E.9060708@sgi.com>
	<20140327132354.GU29498@order.stressinduktion.org>
In-Reply-To: <20140327132354.GU29498@order.stressinduktion.org>
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
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: xfs@oss.sgi.com

On 03/27/14 08:23, Hannes Frederic Sowa wrote:
> On Thu, Mar 27, 2014 at 08:14:06AM -0500, Mark Tinguely wrote:
>> Have you tried to run a xfs_repair on the filesystem after the reboot?
>
> Yes, I did. I still use the filesystem and it works. As soon as I try to
> remove the directory again the same splash from above happens again.

Is it the latest xfsprogs' repair?

Do you have the output from the repair still?


>> Do you fill the filesystem with the test or just part way?
>
> Just part way. The problem certainly appears with 100_000 created directories.
>
> Greetings,
>
>    Hannes


okay thanks.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
