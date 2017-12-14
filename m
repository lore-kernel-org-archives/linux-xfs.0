Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57766 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750720AbdLNGet (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:34:49 -0500
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] fs/*/Kconfig: drop links to 404-compliant
 http://acl.bestbits.at
From: "Yan, Zheng" <zyan@redhat.com>
In-Reply-To: <20171213053825.10903-1-kilobyte@angband.pl>
Date: Thu, 14 Dec 2017 14:34:27 +0800
Content-Transfer-Encoding: 8BIT
Message-Id: <7C5A4F68-5893-4EC7-99D6-8235C8DA1381@redhat.com>
References: <20171213053825.10903-1-kilobyte@angband.pl>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>, v9fs-developer@lists.sourceforge.net, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, ceph-devel <ceph-devel@vger.kernel.org>, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org



> On 13 Dec 2017, at 13:38, Adam Borowski <kilobyte@angband.pl> wrote:
> 
> This link is replicated in most filesystems' config stanzas.  Referring
> to an archived version of that site is pointless as it mostly deals with
> patches; user documentation is available elsewhere.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
> Sending this as one piece; if you guys would instead prefer this chopped
> into tiny per-filesystem bits, please say so.
> 
> 
> Documentation/filesystems/ext2.txt |  2 --
> Documentation/filesystems/ext4.txt |  7 +++----
> fs/9p/Kconfig                      |  3 ---
> fs/Kconfig                         |  6 +-----
> fs/btrfs/Kconfig                   |  3 ---
> fs/ceph/Kconfig                    |  3 —

Ceph bits looks good.

Acked-by:  Yan, Zheng" <zyan@redhat.com>

