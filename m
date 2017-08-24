Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36725 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753351AbdHXQZI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 12:25:08 -0400
Received: by mail-oi0-f44.google.com with SMTP id t196so9914157oif.3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2017 09:25:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170824160846.GA27591@lst.de>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824160846.GA27591@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 09:25:07 -0700
Message-ID: <CAPcyv4iFLZCi=xMCQH+HOjnqZEPLOVUuPkcVCTS6V=8QGpP8ag@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] MAP_DIRECT and block-map-atomic files
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, David Airlie <airlied@linux.ie>, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Takashi Iwai <tiwai@suse.com>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, Jeff Moyer <jmoyer@redhat.com>, Linux MM <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Daniel Vetter <daniel.vetter@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>

On Thu, Aug 24, 2017 at 9:08 AM, Christoph Hellwig <hch@lst.de> wrote:
> This seems to be missing patches 1 and 3.

Sorry, I didn't cc you directly on those. They're on the list:

https://patchwork.kernel.org/patch/9918657/
https://patchwork.kernel.org/patch/9918663/
