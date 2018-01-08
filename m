Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754169AbeAHSBU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jan 2018 13:01:20 -0500
Date: Mon, 8 Jan 2018 18:59:10 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v4 06/19] btrfs: convert to new i_version API
Message-ID: <20180108175910.GE13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171222120556.7435-1-jlayton@kernel.org>
 <20171222120556.7435-7-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171222120556.7435-7-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Fri, Dec 22, 2017 at 07:05:43AM -0500, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Acked-by: David Sterba <dsterba@suse.com>
