Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390210AbfEXQgG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 May 2019 12:36:06 -0400
Date: Fri, 24 May 2019 12:36:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] kernel.h: Add generic roundup_64() macro
Message-ID: <20190524123602.402c01b4@gandalf.local.home>
In-Reply-To: <bd4a85fc-dc56-aae0-4986-003ad4a11ef4@suse.com>
References: <20190523100013.52a8d2a6@gandalf.local.home>
        <CAHk-=wg5HqJ2Kfgpub+tCWQ2_FiFwEW9H1Rm+an-BLGaGvDDXw@mail.gmail.com>
        <20190523112740.7167aba4@gandalf.local.home>
        <e4e875f0-2aa5-89f4-f462-78bedb9c5cde@filmlight.ltd.uk>
        <20190524112656.5ef67c6c@gandalf.local.home>
        <bd4a85fc-dc56-aae0-4986-003ad4a11ef4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: Roger Willcocks <roger@filmlight.ltd.uk>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>, nouveau@lists.freedesktop.org, linux-rdma <linux-rdma@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Fri, 24 May 2019 19:30:45 +0300
Nikolay Borisov <nborisov@suse.com> wrote:


> > Yes I do. I corrected it in my next email.
> > 
> >  http://lkml.kernel.org/r/20190523133648.591f9e78@gandalf.local.home  
> 
> Or perhaps just using is_power_of_2 from include/linux/log2.h ?

Even better. Thanks,

-- Steve
