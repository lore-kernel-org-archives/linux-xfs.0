Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8Q6HJnR125200 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 01:17:19 -0500
Date: Mon, 26 Sep 2011 08:15:56 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] Add test 257: Check proper FITRIM argument
 handling
In-Reply-To: <201109240104.08410@zmi.at>
Message-ID: <alpine.LFD.2.00.1109260814110.3806@dhcp-27-109.brq.redhat.com>
References: <1316787311-23428-1-git-send-email-lczerner@redhat.com>
	<1316787311-23428-2-git-send-email-lczerner@redhat.com>
	<201109240104.08410@zmi.at>
MIME-Version: 1.0
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Lukas Czerner <lczerner@redhat.com>, aelder@sgi.com, xfs@oss.sgi.com

On Sat, 24 Sep 2011, Michael Monnerie wrote:

> On Freitag, 23. September 2011 Lukas Czerner wrote:
> > +# FS QA Test No. 251
> > +#
> > +# This test was created in order to verify filesystem FITRIM
> > implementation. +# By many concurrent copy and remove operations and
> > checking that files +# does not change after copied into SCRATCH_MNT
> > test if FITRIM implementation +# corrupts the filesystem
> > (data/metadata).
> 
> This is a bit misspelled and (for me being non-native english) hard to 
> understand. I guess it should be
> 
> This test was created in order to verify the filesystem FITRIM 
> implementation by doing many concurrent copy and remove operations and
> checking that files do not change after being copied into SCRATCH_MNT.
> Test if FITRIM implementation corrupts the filesystem (data/metadata).
> 
> (Where I'm not sure if the last sentence belongs there, or in a separate 
> paragraph, or is redundant to the first sentence)
> 

Oops, the whole paragraph does not belong there. It is leftover from a
different test I have wrote earlier. Thanks for noticing it and sorry
for the confusion.

-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
