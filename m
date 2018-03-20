Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:39406 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752266AbeCTJcs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 05:32:48 -0400
Received: by mail-oi0-f47.google.com with SMTP id q71-v6so751429oic.6
        for <linux-xfs@vger.kernel.org>; Tue, 20 Mar 2018 02:32:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180320014709.GC1150@dastard>
References: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
 <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com>
 <20180317212814.GI7000@dastard> <CAOQ4uxit=nHvd2C080QeM27icSFra+0Anwu8vXqs4sd=8tCCNg@mail.gmail.com>
 <20180318230259.GJ7000@dastard> <CAOQ4uxiHkW41RB4LogWi8+rp_NhoC+SHGNY9_ShdQi7OyJTTVA@mail.gmail.com>
 <20180320014709.GC1150@dastard>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 20 Mar 2018 10:32:47 +0100
Message-ID: <CAJfpegt6CrMSXETm+MQoGDBOzuc24bbV1TasAsqXXz5KxC+VHQ@mail.gmail.com>
Subject: Re: Question about XFS_MAXINUMBER
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 20, 2018 at 2:47 AM, Dave Chinner <david@fromorbit.com> wrote:

>> Second, and this may be a revolutionary argument, I would like to
>> believe that we are all working together for a "greater good".
>
> I don't say no for the fun of saying no. I say no because I think
> something is a bad idea. Just because I say no doesn't mean I don't
> don't want to solve the problem. It just means that I think the
> solution being presented is a bad idea and we need to explore the
> problem space for a more robust solution.

Totally agreed, let's do that.  I've presented the issues I see with
creating a generic (i.e. non-multiplexing) inode number mapping for
overlayfs in answer to Ian's mail.

Do you see a way this problem can be solved without those issues?

Thanks,
Miklos
