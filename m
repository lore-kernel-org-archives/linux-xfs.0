Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E41497F53
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 16:11:35 -0600 (CST)
Date: Thu, 16 Jan 2014 16:11:32 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/5] xfstests: fix minor build warning
Message-ID: <20140116221132.GK1935@sgi.com>
References: <cover.1389891730.git.dsterba@suse.cz>
	<46203afc2c2423b9df110a38be39c632dd83d5c7.1389891730.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <46203afc2c2423b9df110a38be39c632dd83d5c7.1389891730.git.dsterba@suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: David Sterba <dsterba@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, Jan 16, 2014 at 06:07:11PM +0100, David Sterba wrote:
> Make in the toplevel directory tries to process the 'group' file that
> existed in the previous file layout
> 
> $ make
>  sed: can't read group: No such file or directory
>  sed: can't read group: No such file or directory
>  ...
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
