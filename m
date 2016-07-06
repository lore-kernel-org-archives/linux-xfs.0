Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F95D7D05
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 06:49:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F38F6304032
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 04:49:32 -0700 (PDT)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id 3EdJKTrbc4ldPLOM for
	<xfs@oss.sgi.com>; Wed, 06 Jul 2016 04:49:30 -0700 (PDT)
Message-ID: <1467805769.7631.249.camel@filmlight.ltd.uk>
Subject: Re: Bad Metadata performances for XFS?
From: Roger Willcocks <roger@filmlight.ltd.uk>
Date: Wed, 06 Jul 2016 12:49:29 +0100
In-Reply-To: <CAJCQCtRiznrWAmCEgd=uMETnBubh1ZttGP4xF9PLu0_j7XBRuw@mail.gmail.com>
References: <3ED34739A4E85E4F894367D57617CDEF9ED9518B@LAX-EX-MB2.datadirect.datadirectnet.com>
	<20160704225226.GD27480@dastard> <20160705001854.GY12670@dastard>
	<3ED34739A4E85E4F894367D57617CDEF9ED955AB@LAX-EX-MB2.datadirect.datadirectnet.com>
	<CAJCQCtRiznrWAmCEgd=uMETnBubh1ZttGP4xF9PLu0_j7XBRuw@mail.gmail.com>
Mime-Version: 1.0
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
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Wang Shilong <wshilong@ddn.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, 2016-07-05 at 14:34 -0600, Chris Murphy wrote:
> On Mon, Jul 4, 2016 at 7:43 PM, Wang Shilong <wshilong@ddn.com> wrote:
> >
> >
> > I understand that this is single thread Limit, but I guess there are some
> > other Limit here, because even single thread creating 50W files speed
> > is twice than 200W files.
> 
> Watts or Wolframs (tungsten)?
> 
> 50W!=50000. You could write it as 50k and 200k. It's unlikely to get
> confused with 50K and 200K, which are temperatures, because of
> context. But W makes no sense.
> 
> 
> 

I suspect it's an abbreviation for the (Chinese) unit 'wan'

https://www.quora.com/Why-do-Chinese-people-count-in-units-of-10-000

so it makes perfect sense but it's not an SI unit.

--
Roger


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
