Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:43307 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751730AbeFFLiv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jun 2018 07:38:51 -0400
Received: by mail-io0-f172.google.com with SMTP id t6-v6so7195168iob.10
        for <linux-xfs@vger.kernel.org>; Wed, 06 Jun 2018 04:38:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180606104033.4947-1-hch@lst.de>
References: <20180606104033.4947-1-hch@lst.de>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 6 Jun 2018 13:38:50 +0200
Message-ID: <CAHc6FU458f9xkr2ru2B2L8_FC+=vm5CLDUixBjCZSq5YZZC8=w@mail.gmail.com>
Subject: Re: iomap preparations for GFS2
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>

On 6 June 2018 at 12:40, Christoph Hellwig <hch@lst.de> wrote:
> Hi all,
>
> this is a slight rework of the patches from Andreas to prepare for gfs2
> using the iomap code.  I'd like to start with an immutable branch for
> iomap patches in either the XFS tree or a tree of mine own with something
> like this so that we can have a nice common base for both the major
> iomap changes for XFS and the GFS2 work.

Okay.

Thanks,
Andreas
