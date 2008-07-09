Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 00:13:06 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m697D3aZ024158
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 00:13:04 -0700
Received: from pomaz-ex.szeredi.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F2461895C27
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 00:14:08 -0700 (PDT)
Received: from pomaz-ex.szeredi.hu (fxip-0047f.externet.hu [88.209.222.127]) by cuda.sgi.com with ESMTP id IGlmGKjfwvKGAsNE for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 00:14:08 -0700 (PDT)
In-reply-to: <20080709065950.GR11558@disturbed> (message from Dave Chinner on
	Wed, 9 Jul 2008 16:59:50 +1000)
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <20080709065950.GR11558@disturbed>
Message-Id: <E1KGTrq-0006qj-1u@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jul 2008 09:13:34 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: david@fromorbit.com
Cc: arjan@infradead.org, miklos@szeredi.hu, hch@infradead.org, tytso@mit.edu, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Wed, 9 Jul 2008, Dave Chinner wrote:
> The argument against Miklos' version is that there may be multiple
> commands to execute while the fs is frozen.

Which is what a shell is for ;)

Miklos
