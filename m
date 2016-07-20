Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ADE107CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 09:00:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7000D8F8037
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 07:00:43 -0700 (PDT)
Received: from mail-it0-f54.google.com (mail-it0-f54.google.com
	[209.85.214.54]) by cuda.sgi.com with ESMTP id VAn0f1EgnnO3RHCW
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Jul 2016 07:00:41 -0700 (PDT)
Received: by mail-it0-f54.google.com with SMTP id j124so50921319ith.1
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 07:00:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160720090406.GA3094@redhat.com>
References: <1468922657-3895-1-git-send-email-cmaiolino@redhat.com>
	<94b928aa-70f7-dbf4-66a8-a5f6ca2a4944@sandeen.net>
	<c1db85e5-5537-0105-4fa5-4b6512333d96@sandeen.net>
	<20160720090406.GA3094@redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 20 Jul 2016 16:00:21 +0200
Message-ID: <CACj3i70DEaLbQuJC1mj3XizLAQOoNsoogB9t_1FA9oqBKgVmOA@mail.gmail.com>
Subject: Re: [PATCH] xfs: Document error handling behavior
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jul 20, 2016 at 11:04 AM, Carlos Maiolino <cmaiolino@redhat.com> wrote:
>
> IMHO, if someone want to take a look into filesystem documentation, the person
> goes directly to Documentation/filesystems, I honestly think splitting
> information into two different directories are wrong, and, even though you point
> to there in some other place, it is still bad, sounds like a RPG book... Start
> here...now go to page X...now go to page Y...now go to page Z.
>

I'm sorry for this offtopic, but I would almost bet that I saw a game
made in man pages. Yet Google can't find anything, so maybe it is a
kind of deja vu, or a common experience... :(

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
