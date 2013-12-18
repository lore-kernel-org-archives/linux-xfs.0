Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 464AD7F3F
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 02:33:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12C86304077
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 00:33:24 -0800 (PST)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
	[209.85.212.171]) by cuda.sgi.com with ESMTP id
	pP74y3hlzHyvwtf3 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 00:33:23 -0800 (PST)
Received: by mail-wi0-f171.google.com with SMTP id bz8so4893873wib.10
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 00:33:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52B102FF.8040404@pzystorm.de>
References: <52B102FF.8040404@pzystorm.de>
Date: Wed, 18 Dec 2013 09:33:22 +0100
Message-ID: <CAAxjCEw+-B7cYdL0SZ903n0ZpKoqmS7sZZQiPQK8-qut6=ia3g@mail.gmail.com>
Subject: Re: XFS blocked task in xlog_cil_force_lsn
From: Stefan Ring <stefanrin@gmail.com>
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
To: xfs@pzystorm.de
Cc: Linux fs XFS <xfs@oss.sgi.com>

> Even a reboot is now not possible anymore, because the whole system
> hangs while executing the "sync" command in one of the shutdown scripts.

This is unusual. How long have you waited?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
