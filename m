Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAA5C25B45
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Oct 2023 20:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjJWUAF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 16:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjJWUAF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2023 16:00:05 -0400
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA658F
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 13:00:01 -0700 (PDT)
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:39444)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1qv15h-00HJlM-BR
        for linux-xfs@vger.kernel.org; Mon, 23 Oct 2023 19:59:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=KVdG8+rk+DtqE6a1djfRcKeBoqIWpsGEgPgy9taLZOc=; b=dwW84Z8rfgdmp8q7PVngzy2IaN
        7ZhRJcU5ToWrC1c0+qdF1IjDztuYvxXxqzTPoaEfqswneh/uadMUT6bUGVhYmc3Hr4yi1fMBoD47I
        QKlTQMzOTBRRy/LrbB9JPjlGjBb6U05HIvYQgXa0Y03nCvkpIYV6PgTCMtuZa7APIYrzY7zqgfkrV
        +LK5aZWt6YTSukxD43DuVIx/q6VdxMxmJrcjwsZ+1naIhU0Y2OS/ACpin4TcAREZJ9AA3u2adVs+x
        zvMb86viQ+9Ms8OclS2kywsKQ04lNEI0uGXkl8Zm45UH6OcHb48/+b2MWbalJbwjDSvwzHcJ5hhqt
        zxv+r0AQ==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1qv15g-001d34-5c
        for linux-xfs@vger.kernel.org; Mon, 23 Oct 2023 19:59:56 +0000
To:     linux-xfs@vger.kernel.org
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.5.0-1_source.changes
Date:   Mon, 23 Oct 2023 19:59:56 +0000
X-Debian: DAK
X-DAK:  DAK
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1qv15g-001d34-5c@usper.debian.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs_6.5.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.5.0-1.dsc
  xfsprogs_6.5.0.orig.tar.xz
  xfsprogs_6.5.0-1.debian.tar.xz
  xfsprogs_6.5.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
