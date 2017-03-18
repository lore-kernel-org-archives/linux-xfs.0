Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:38969 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750971AbdCRHIu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Mar 2017 03:08:50 -0400
Date: Sat, 18 Mar 2017 18:08:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/22] mkfs.xfs: Make stronger conflict checks
Message-ID: <20170318070847.GY17542@dastard>
References: <20170315160017.27805-1-jtulak@redhat.com>
 <20170316233845.GY28800@wotan.suse.de>
 <2030b8be-4fe0-c767-4c3a-0e5ff25c4362@sandeen.net>
 <CACj3i72OB8Ywx-vomuT+jV5P7KFVZN-4g=NssTXX6W_G8MjQ1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i72OB8Ywx-vomuT+jV5P7KFVZN-4g=NssTXX6W_G8MjQ1w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Fri, Mar 17, 2017 at 01:57:10PM +0100, Jan Tulak wrote:
> On Fri, Mar 17, 2017 at 12:47 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> > On 3/16/17 4:38 PM, Luis R. Rodriguez wrote:
> >> On Wed, Mar 15, 2017 at 04:59:55PM +0100, Jan Tulak wrote:
> > I'll probably keep flinging comments on various patches as I read them,
> > some of it may be helpful in terms of just learning some best practice
> > for patches, but TBH I'm still trying to wrap my head around the big change
> > and purpose.
> >
> 
> OK. We can talk about it next week personally if needed. And decide
> whether it is worth to reorganise this set into no-op and op changes.

It's better to discuss this sort of thing on the mailing list so
that every sees the explanations and understands the reasons for the
changes being made....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
