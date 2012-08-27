Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7RHNnZ5223376 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 12:23:49 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id KfsE4K3ibJ91r2RV for <xfs@oss.sgi.com>;
	Mon, 27 Aug 2012 10:24:39 -0700 (PDT)
Message-ID: <503BAD56.3060402@sandeen.net>
Date: Mon, 27 Aug 2012 12:24:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: test dump/restore of 32-bit projids
References: <CAFZPdfhbMU3uNDt8wWA3KbsgPg2s0g6e0LUGkHCmdn0vryB8kQ@mail.gmail.com>
In-Reply-To: <CAFZPdfhbMU3uNDt8wWA3KbsgPg2s0g6e0LUGkHCmdn0vryB8kQ@mail.gmail.com>
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
To: Boris Ranto <ranto.boris@gmail.com>
Cc: Bill Kendall <wkendall@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On 8/27/12 4:52 AM, Boris Ranto wrote:
> On Sun, 2012-08-26 at 22:27 -0500, Eric Sandeen wrote:
>>Test that xfsdump/xfsrestore properly restores more than the
>> bottom 16 bits of a 32-bit projid.
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net <mailto:sandeen@sandeen.net>>
>> ---

...

> I've been working on a xfstests projid32bit test case, too. It covers this area + few others. I'll post that one, soon.

Ok, if yours tests more we should just use it when it's ready, I think.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
