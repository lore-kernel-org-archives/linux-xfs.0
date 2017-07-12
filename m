Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932080AbdGLRS2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jul 2017 13:18:28 -0400
Date: Wed, 12 Jul 2017 18:10:54 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [proposal] making filesystem tools more machine friendly
Message-ID: <20170712171054.GB19996@redhat.com>
References: <CACj3i70p=ybXZWRncseqwnbs7HAYu-SL02+cj--7T5YnqcwVKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i70p=ybXZWRncseqwnbs7HAYu-SL02+cj--7T5YnqcwVKQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs <linux-xfs@vger.kernel.org>


libguestfs could really use structured output from more of the command
line tools.  Particularly:

 - all the ext4 tools
 - all the xfs tools
 - all the btrfs tools
 - parted

and more.  See also:

  https://github.com/libguestfs/libguestfs/tree/master/daemon

A dbus service would not be useful.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-builder quickly builds VMs from scratch
http://libguestfs.org/virt-builder.1.html
