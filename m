Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Sep 2008 19:02:22 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9122ICo011306
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2008 19:02:19 -0700
Subject: TAKE 986558 - Update kernel headers for user-space libxfs build support
Message-Id: <20081001020346.DD11F58C52B4@chook.melbourne.sgi.com>
Date: Wed,  1 Oct 2008 12:03:46 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Sync up kernel and user-space headers

Date:  Wed Oct  1 12:01:55 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32231a
fs/xfs/xfs_ialloc.h - 1.51 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.h.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
fs/xfs/xfs_ag.h - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ag.h.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
fs/xfs/xfs_da_btree.h - 1.72 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.h.diff?r1=text&tr1=1.72&r2=text&tr2=1.71&f=h
fs/xfs/xfs_bit.h - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bit.h.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
fs/xfs/xfs_arch.h - 1.55 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_arch.h.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
fs/xfs/xfs_inode_item.h - 1.53 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.h.diff?r1=text&tr1=1.53&r2=text&tr2=1.52&f=h
fs/xfs/xfs_bmap_btree.h - 1.91 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.91&r2=text&tr2=1.90&f=h
fs/xfs/xfs_mount.h - 1.276 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.276&r2=text&tr2=1.275&f=h
fs/xfs/xfs_btree.h - 1.97 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.97&r2=text&tr2=1.96&f=h
fs/xfs/xfs_inode.h - 1.259 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.259&r2=text&tr2=1.258&f=h
fs/xfs/xfs_trans.h - 1.152 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.152&r2=text&tr2=1.151&f=h
fs/xfs/xfs_alloc.h - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.h.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
fs/xfs/xfs_imap.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_imap.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
fs/xfs/xfs_bmap.h - 1.105 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.h.diff?r1=text&tr1=1.105&r2=text&tr2=1.104&f=h
	- Sync up kernel and user-space headers
