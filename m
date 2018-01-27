Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:39485 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752132AbeA0Ie0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Jan 2018 03:34:26 -0500
Received: by mail-yb0-f178.google.com with SMTP id 65so1059305ybz.6
        for <linux-xfs@vger.kernel.org>; Sat, 27 Jan 2018 00:34:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180125055144.qztiqeakw4u3pvqf@destitution>
References: <20180125055144.qztiqeakw4u3pvqf@destitution>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 27 Jan 2018 10:34:25 +0200
Message-ID: <CAOQ4uxiCN1yXFOs--pQhEczk8SyXX+-gk5QKF_2YO-VvvZ0sVw@mail.gmail.com>
Subject: Re: [RFD] XFS: Subvolumes and snapshots....
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jan 25, 2018 at 7:51 AM, Dave Chinner <david@fromorbit.com> wrote:
>
> The video from my talk at LCA 2018 yesterday about the XFS subvolume and
> snapshot support I'm working on has been uploaded and can be found
> here:
>
> https://www.youtube.com/watch?v=wG8FUvSGROw
>
> I don't have the code in a reviewable form yet - there's still quite
> a bit of work before I get to that point, but this is a good
> introduction to how all the pieces will fit together....
>

Very cool!

Got any paper napkin design photo to share?

What are the big unknowns at this point?

Is the data part challenging because of no buffer cache for data?

I suppose all subvolumes use the host fs journal?

Not gonna share this master plan with fsdevel?

Cheers,
Amir.
