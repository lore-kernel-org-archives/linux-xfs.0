Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E05C37F61
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 12:16:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6AE30AC006
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 10:16:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7jFwNtH7aG2HOXh2 for <xfs@oss.sgi.com>;
	Thu, 11 Jun 2015 10:16:15 -0700 (PDT)
Message-ID: <5579C25F.6090508@sandeen.net>
Date: Thu, 11 Jun 2015 12:16:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
References: <5579296A.8010208@skylable.com>	<20150611151620.GB59168@bfoster.bfoster>	<5579A904.3020204@skylable.com>	<5579AE85.5080203@sandeen.net>
	<5579B034.4070503@sandeen.net> <5579B804.9050707@skylable.com>
	<5579C0EE.1050503@sandeen.net> <5579C1C7.6050109@skylable.com>
In-Reply-To: <5579C1C7.6050109@skylable.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?windows-1252?Q?T=F6r=F6k_Edwin?= <edwin@skylable.com>, Brian Foster <bfoster@redhat.com>
Cc: Christopher Squires <christopher.squires@hgst.com>, Wayne Burri <wayne.burri@hgst.com>, Luca Gibelli <luca@skylable.com>, xfs@oss.sgi.com

On 6/11/15 12:13 PM, T=F6r=F6k Edwin wrote:
> It is persistent. I tried remounting, or unmount + xfs_repair +
> remount, or rm -rf /export/dfs/a, but once its corrupted it stays
> like that.

That narrows it down, thanks.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
