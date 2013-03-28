Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BEA9C7F37
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 11:13:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AEB7B30407F
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 09:13:04 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	REu3s6JFZ4AM1pp4 for <xfs@oss.sgi.com>;
	Wed, 27 Mar 2013 17:51:47 -0700 (PDT)
Date: Thu, 28 Mar 2013 11:51:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Crash with 3.8.3 and TuxOnIce
Message-ID: <20130328005145.GZ6369@dastard>
References: <CAEDdjHeo3Giv3Y8pLfYHSbJi07_dv7ywzinCSSkxUwBQe-1fsw@mail.gmail.com>
	<20130327233912.GU22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130327233912.GU22182@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Pedro Ribeiro <pedrib@gmail.com>, xfs@oss.sgi.com

On Wed, Mar 27, 2013 at 06:39:12PM -0500, Ben Myers wrote:
> On Tue, Mar 19, 2013 at 11:31:16PM +0000, Pedro Ribeiro wrote:
> > I'm using a TuxOnIce enabled kernel, and recently moved from 3.7.1 to
> > 3.8.3. The former used to work nicely, but now I get a hard crash when I
> > try to hibernate.
> > This is solely related to TuxOnIce as it does not happen in the default
> > hibernation.
> > 
> > I know this is an unsupported out of tree patch, but can you please help me
> > debug it or point in the right direction?
> > 
> > Unfortunately as this was a kernel crash all I have are crappy photos, but
> > they do show a readable stack trace:
> > img18[dot]imageshack[dot]us/img18/395/imag0228hp[dot]jpg
> > img13[dot]imageshack[dot]us/img13/4375/imag0231p[dot]jpg
> 
> The admin made a change change in mailer settings.  Lets see if it works now:
> http://img18.imageshack.us/img18/395/imag0228hp.jpg

Thanks, Ben. it works just fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
