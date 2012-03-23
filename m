Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2N5AQVp105262 for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 00:10:27 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ICqBFyUDVCUALBBd
	for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 22:10:25 -0700 (PDT)
Message-ID: <4F6C05C1.4020204@hardwarefreak.com>
Date: Fri, 23 Mar 2012 00:10:25 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<4F64115D.50208@hardwarefreak.com> <20120317223454.GQ5091@dastard>
	<20325.17387.216150.45013@tree.ty.sabi.co.UK>
	<20325.50714.237894.328039@tree.ty.sabi.co.UK>
	<4F6624A3.5010206@hardwarefreak.com>
	<20331.39194.377610.888636@tree.ty.sabi.co.UK>
In-Reply-To: <20331.39194.377610.888636@tree.ty.sabi.co.UK>
Reply-To: stan@hardwarefreak.com
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
To: Peter Grandi <pg@lxra2.to.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>

On 3/22/2012 4:26 PM, Peter Grandi wrote:

[snipped 2-3 pages of redundant nonsense, linked docs, and filesystem
concepts everyone is already familiar with]

> Overselling 'delaylog' with cheeky propaganda glossing over the
> heavy tradeoffs involved is understandable, but quite wrong.

And now we come full circle to what started this mess of a discussion:
Peter's dislike of Dave's presentation of delaylog, and XFS in general,
at linux.conf.au.

Peter, if *you* had been giving Dave's presentation at linux.conf.au,
how would *you* have presented delayed logging differently?  How much
time would you have spent warning of the dangers of potential data loss
upon a crash and how would you have presented it?  Note I'm not asking
you to re-critique Dave's presentation.  I'm asking you to write your
own short presentation of the delayed logging feature, so we can all see
it done the right way, without "cheeky propaganda" and without "glossing
over the heavy tradeoffs".

We're all on the edge of our seats, eagerly awaiting your expert XFS
presentation Peter.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
